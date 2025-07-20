import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({super.key});

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  bool isManual = true;
  double redIntensity = 70;
  double greenIntensity = 50;
  double blueIntensity = 30;

  late MqttServerClient client;

  @override
  void initState() {
    super.initState();
    _setupMQTT();
  }

  Future<void> _setupMQTT() async {
    client = MqttServerClient.withPort(
      'broker.hivemq.com',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      1883,
    );
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = () {
      debugPrint("MQTT Disconnected");
    };

    try {
      await client.connect();
      debugPrint("✅ MQTT connected");
    } catch (e) {
      debugPrint("❌ MQTT connection failed: $e");
      client.disconnect();
    }
  }

  void _publishRGBValues() {
    if (!isManual ||
        client.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }

    final r = ((redIntensity / 100) * 255).toInt();
    final g = ((greenIntensity / 100) * 255).toInt();
    final b = ((blueIntensity / 100) * 255).toInt();

    final json = '{"r":$r,"g":$g,"b":$b}';
    final builder = MqttClientPayloadBuilder();
    builder.addString(json);

    client.publishMessage(
      'hydrogrow/ledcontrol',
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: false,
    );

    debugPrint("📤 Sent: $json");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          children: [
            _controlModeCard(),
            const SizedBox(height: 16),
            _rgbControlCard(),
            const SizedBox(height: 16),
            _lightPresetsCard(),
          ],
        ),
      ),
    );
  }

  Widget _controlModeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Control Mode',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Lighting Control"),
              Row(
                children: [
                  Text(
                    isManual ? "Manual" : "Auto",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: isManual,
                    onChanged: (val) {
                      setState(() {
                        isManual = val;
                      });
                      _publishRGBValues(); // send update on mode toggle
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rgbControlCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manual RGB Control',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSliderRow("Red Intensity", redIntensity, (value) {
            setState(() {
              redIntensity = value;
            });
            _publishRGBValues();
          }, Colors.red),
          _buildSliderRow("Green Intensity", greenIntensity, (value) {
            setState(() {
              greenIntensity = value;
            });
            _publishRGBValues();
          }, Colors.green),
          _buildSliderRow("Blue Intensity", blueIntensity, (value) {
            setState(() {
              blueIntensity = value;
            });
            _publishRGBValues();
          }, Colors.blue),
        ],
      ),
    );
  }

  Widget _lightPresetsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Light Presets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _presetButton(
                Icons.wb_sunny_outlined,
                "Daylight",
                color: const Color.fromARGB(255, 243, 221, 32),
                r: 255,
                g: 225,
                b: 32,
              ),
              _presetButton(
                Icons.eco_outlined,
                "Growth Mode",
                color: Colors.green,
                r: 0,
                g: 255,
                b: 0,
              ),
              _presetButton(
                Icons.nightlight_outlined,
                "Night Mode",
                color: const Color.fromARGB(255, 76, 94, 175),
                r: 10,
                g: 10,
                b: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    ValueChanged<double> onChanged,
    Color activeColor,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${value.toInt()}%',
              style: TextStyle(color: activeColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _presetButton(
    IconData icon,
    String label, {
    Color color = Colors.green,
    required int r,
    required int g,
    required int b,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          redIntensity = (r / 255) * 100;
          greenIntensity = (g / 255) * 100;
          blueIntensity = (b / 255) * 100;
        });
        _publishRGBValues();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
