import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ExpansionTile(
            title: Text("How do I change light settings?"),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Go to Settings > Configure Thresholds."),
              )
            ],
          ),
          ExpansionTile(
            title: Text("What to do when the sensor is not responding?"),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Check your wiring or reconnect the sensor."),
              )
            ],
          ),
          ExpansionTile(
            title: Text("How to contact support?"),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Email us at: support@hydrogrow.com"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
