import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:hydrogrow_fixed/help_and_support.dart';
import 'package:hydrogrow_fixed/lights.dart';
import 'package:hydrogrow_fixed/alerts.dart';
import 'package:hydrogrow_fixed/settings.dart';
import 'package:hydrogrow_fixed/threshold.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ThresholdPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AlertsPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LightsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DashboardContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Threshold'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Lights'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  late MqttServerClient client;

  double temperature = 0;
  double humidity = 0;
  int soil = 0;
  int ldr = 0;

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
    _connectToBroker();
  }

  void _setupMqttClient() {
    client = MqttServerClient('broker.hivemq.com', '');
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.logging(on: false);
    client.autoReconnect = true;
    client.onDisconnected = _onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(
          'hydrogrow_flutter_${DateTime.now().millisecondsSinceEpoch}',
        )
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;
  }

  Future<void> _connectToBroker() async {
    try {
      await client.connect();
    } catch (e) {
      debugPrint("❌ Could not connect: $e");
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) _connectToBroker();
      });
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint("✅ Connected to MQTT broker.");
      client.subscribe('hydrogrow/sensordata', MqttQos.atLeastOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>> events) {
        final MqttPublishMessage recMess =
            events[0].payload as MqttPublishMessage;

        final payloadBuffer = recMess.payload.message;
        final jsonString = MqttPublishPayload.bytesToStringAsString(
          payloadBuffer,
        );

        debugPrint("📨 Received: $jsonString");

        try {
          final data = jsonDecode(jsonString);

          if (data is Map<String, dynamic> && mounted) {
            setState(() {
              temperature = (data['temperature'] ?? 0).toDouble();
              humidity = (data['humidity'] ?? 0).toDouble();
              soil = (data['soilMoisture'] ?? 0).toInt();
              ldr = (data['light'] ?? 0).toInt();
            });
          }
        } catch (e) {
          debugPrint("⚠️ JSON parse error: $e");
        }
      });
    } else {
      debugPrint("❌ MQTT status: ${client.connectionStatus}");
    }
  }

  void _onDisconnected() {
    debugPrint("⚠️ Disconnected from broker.");
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _connectToBroker();
    });
  }

  Widget sensorCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6FA),
      padding: const EdgeInsets.all(12),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          children: [
            SizedBox(
              height: 420,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  sensorCard(
                    icon: Icons.water_drop_outlined,
                    label: "Soil Moisture",
                    value: "$soil",
                  ),
                  sensorCard(
                    icon: Icons.thermostat_outlined,
                    label: "Temperature",
                    value: "${temperature.toStringAsFixed(1)}°C",
                  ),
                  sensorCard(
                    icon: Icons.air_outlined,
                    label: "Humidity",
                    value: "${humidity.toStringAsFixed(1)}%",
                  ),
                  sensorCard(
                    icon: Icons.light_mode_outlined,
                    label: "Light (LDR)",
                    value: "$ldr",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 700,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "Soil Moisture Trends (24h)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Device status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
