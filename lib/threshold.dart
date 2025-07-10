import 'package:flutter/material.dart';

class ThresholdPage extends StatefulWidget {
  const ThresholdPage({super.key});

  @override
  State<ThresholdPage> createState() => _ThresholdPageState();
}

class _ThresholdPageState extends State<ThresholdPage> {
  double soilMoisture = 60;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F6FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌱 Soil Moisture Threshold
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.water_drop, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Soil Moisture Threshold",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${soilMoisture.toInt()}%",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: soilMoisture,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: "${soilMoisture.toInt()}%",
                    onChanged: (value) {
                      setState(() {
                        soilMoisture = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.shade100,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🌡️ Air Temperature Threshold
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.thermostat, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Air Temperature Threshold",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Min Temp",
                            suffixText: "C",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Max Temp",
                            suffixText: "C",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Set the safe operating temperature range.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 💧 Air Humidity Threshold
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.cloud_circle_rounded, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Air Humidity Threshold",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Min Humidity",
                            suffixText: "%",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Max Humidity",
                            suffixText: "%",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Triggers alerts when humidity is outside this range.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 💡 Light Intensity Threshold
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.light_mode, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Ambient Light Intensity",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Min Light Intensity",
                      suffixText: "lux",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Set the minimum acceptable light level",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
