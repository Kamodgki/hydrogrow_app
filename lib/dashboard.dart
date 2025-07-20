import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:fl_chart/fl_chart.dart';

import 'alerts.dart';
import 'lights.dart';
import 'settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late MqttServerClient client;
  bool isConnected = false;
  String status = "Connecting...";

  double temperature = 0;
  double humidity = 0;
  double soilMoisture = 0;
  double light = 0;

  List<FlSpot> soilHistory = [];
  List<FlSpot> tempHistory = [];
  int counter = 0;

  int currentPage = 0;

  final List<String> _titles = [
    'Dashboard',
    'Lights',
    'Alerts',
    'Settings',
    'Configure Thresholds',
    'Profile',
    'Help and Support',
  ];

  @override
  void initState() {
    super.initState();
    setupMqttClient();
  }

  Future<void> setupMqttClient() async {
    client = MqttServerClient('broker.hivemq.com', '');
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.autoReconnect = true;
    client.setProtocolV311();
    client.clientIdentifier =
        'flutter_client_${DateTime.now().millisecondsSinceEpoch}';

    try {
      print('MQTT: Connecting...');
      await client.connect();

      final statusResult = client.connectionStatus;
      if (statusResult?.state == MqttConnectionState.connected) {
        print('MQTT: Connected successfully');
        setState(() {
          isConnected = true;
          status = "Connected";
        });
      } else {
        print('MQTT: Connection failed - ${statusResult?.state}');
        setState(() {
          isConnected = false;
          status = "Connection Failed";
        });
        client.disconnect();
      }
    } catch (e) {
      print('MQTT: Exception - $e');
      setState(() {
        isConnected = false;
        status = "Connection Error";
      });
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe("hydrogrow/sensordata", MqttQos.atMostOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        print('MQTT: Received: $payload');

        final data = json.decode(payload);

        setState(() {
          temperature = (data['temperature'] ?? 0).toDouble();
          humidity = (data['humidity'] ?? 0).toDouble();
          soilMoisture = (data['soil'] ?? data['soil_moisture'] ?? 0)
              .toDouble();
          light = (data['light'] ?? 0).toDouble();

          counter++;
          soilHistory.add(FlSpot(counter.toDouble(), soilMoisture));
          tempHistory.add(FlSpot(counter.toDouble(), temperature));

          if (soilHistory.length > 20) soilHistory.removeAt(0);
          if (tempHistory.length > 20) tempHistory.removeAt(0);
        });
      });
    }
  }

  void onConnected() {
    print('MQTT: Connected');
    setState(() {
      isConnected = true;
      status = "Connected";
    });
  }

  void onDisconnected() {
    print('MQTT: Disconnected');
    setState(() {
      isConnected = false;
      status = "Disconnected";
    });
  }

  void onSubscribed(String topic) {
    print('MQTT: Subscribed to $topic');
    setState(() {
      status = "Subscribed to $topic";
    });
  }

  Widget sensorCard(String title, double value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLineChart(List<FlSpot> spots, Color color) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            color: color,
            isCurved: true,
            spots: spots,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget getPageForCurrentIndex() {
    switch (currentPage) {
      case 0:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                sensorCard(
                  "Temperature",
                  temperature,
                  Icons.thermostat,
                  Colors.red,
                ),
                sensorCard("Humidity", humidity, Icons.water_drop, Colors.blue),
                sensorCard(
                  "Soil Moisture",
                  soilMoisture,
                  Icons.grass,
                  Colors.brown,
                ),
                sensorCard("Light", light, Icons.wb_sunny, Colors.orange),
                const SizedBox(height: 20),
                const Text("📈 Soil Moisture History"),
                SizedBox(
                  height: 200,
                  child: buildLineChart(soilHistory, Colors.brown),
                ),
                const SizedBox(height: 20),
                const Text("📈 Temperature History"),
                SizedBox(
                  height: 200,
                  child: buildLineChart(tempHistory, Colors.red),
                ),
              ],
            ),
          ),
        );
      case 1:
        return const LightsPage();
      case 2:
        return const AlertsPage();
      case 3:
        return const SettingsPage();
      default:
        return const Center(child: Text("Unknown Page"));
    }
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HydroGrow Dashboard"),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              status,
              style: TextStyle(
                color: isConnected ? Colors.white : Colors.red[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(title: Text('Dashboard')),
            ListTile(title: Text('Lights')),
            ListTile(title: Text('Alerts')),
            ListTile(title: Text('Settings')),
            ListTile(title: Text('Configure Thresholds')),
            ListTile(title: Text('My profile')),
            ListTile(title: Text('Help and Support')),
            ListTile(title: Text('Logout')),
          ],
        ),
      ),
      body: getPageForCurrentIndex(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.light_mode), label: 'Lights'),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
