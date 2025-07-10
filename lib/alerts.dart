import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  final VoidCallback? onNavigateToThreshold;

  const AlertsPage({Key? key, this.onNavigateToThreshold}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Recent Notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              if (onNavigateToThreshold != null) {
                onNavigateToThreshold!();
              }
            },
            icon: const Icon(Icons.settings),
            label: const Text("Configure Alert Threshold"),
          ),
        ],
      ),
    );
  }
}
