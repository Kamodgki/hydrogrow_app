import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Control Mode
            Container(
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // RGB Controls
            Container(
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Red
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Red Intensity'),
                      Text(
                        '${redIntensity.toInt()}%',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: redIntensity,
                    min: 0,
                    max: 100,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        redIntensity = value;
                      });
                    },
                  ),

                  // Green
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Green Intensity'),
                      Text(
                        '${greenIntensity.toInt()}%',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: greenIntensity,
                    min: 0,
                    max: 100,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        greenIntensity = value;
                      });
                    },
                  ),

                  // Blue
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Blue Intensity'),
                      Text(
                        '${blueIntensity.toInt()}%',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: blueIntensity,
                    min: 0,
                    max: 100,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        blueIntensity = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Light Presets
            Container(
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _presetButton(Icons.wb_sunny_outlined, "Daylight"),
                      _presetButton(Icons.eco_outlined, "Growth Mode"),
                      _presetButton(Icons.nightlight_outlined, "Night Mode"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: Colors.green),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
