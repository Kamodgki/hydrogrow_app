import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  final VoidCallback? onNavigateToThreshold;

  const AlertsPage({Key? key, this.onNavigateToThreshold}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            buildNotificationCard(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red,
              message: "Soil moisture critically low, system paused irrigation.",
              time: "2 minutes ago",
              tag: "Urgent",
              tagColor: Colors.red.shade100,
              tagTextColor: Colors.red,
            ),
            buildNotificationCard(
              icon: Icons.lightbulb_outline,
              iconColor: Colors.green,
              message: "Activating grow lights to ensure optimal plant growth",
              time: "15 minutes ago",
              tag: "Info",
              tagColor: Colors.green.shade50,
              tagTextColor: Colors.green,
            ),
            buildNotificationCard(
              icon: Icons.thermostat,
              iconColor: Colors.orange,
              message: "Ambient temperature exceeding optimal range, activate cooling.",
              time: "1 hour ago",
              tag: "Warning",
              tagColor: Colors.orange.shade50,
              tagTextColor: Colors.orange,
            ),
            buildNotificationCard(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              message: "System check complete: All sensors nominal.",
              time: "Yesterday at 10:30 AM",
              tag: "Resolved",
              tagColor: Colors.green.shade50,
              tagTextColor: Colors.green,
            ),
            buildNotificationCard(
              icon: Icons.opacity,
              iconColor: Colors.teal,
              message: "Water reservoir level low, refill recommended soon.",
              time: "Yesterday at 5:00 PM",
              tag: "Info",
              tagColor: Colors.teal.shade50,
              tagTextColor: Colors.teal,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onNavigateToThreshold,
                icon: const Icon(Icons.settings, color: Colors.white),
                label: const Text(
                  "Configure Alert Thresholds",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String message,
    required String time,
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 12, color: tagTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
