import 'package:flutter/material.dart';
import 'profile.dart';
import 'help_and_support.dart';



class SettingsPage extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToHelp;
  const SettingsPage({super.key,
    this.onNavigateToProfile,
    this.onNavigateToHelp,
  }
      );

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child:SingleChildScrollView(
        padding:const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Account Section
            const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),


            const SizedBox(height:8),
            buildSettingsTile(
              icon: Icons.settings,
              title:"Profile & Preferences",
              onPressed:(){
                if (widget.onNavigateToProfile != null) {
                  widget.onNavigateToProfile!();
                }

              },

            ),

            const SizedBox(height:24),
            //Device Section
            const Text(
                "Device", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),

            const SizedBox(height:8),

            buildSettingsTile(
              icon: Icons.wifi,
              title:" WiFi connection",
              onPressed:() {},

            ),

            buildSettingsTile(
              icon: Icons.thermostat,
              title:" Alert Thresholds",
              onPressed:() {},
            ),

            buildSettingsTile(
              icon: Icons.info_outline,
              title:" Device Information",
              onPressed:() {},
            ),

            buildSettingsTile(
              icon: Icons.system_update,
              title:" Firmware Update",
              onPressed:() {},
            ),

            const SizedBox(height: 24),
            // General Section
            const Text(
              "General",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height:8),
            buildSettingsTile(
              icon: Icons.language,
              title:" Language & Region ",
              onPressed:() {},
            ),

            const SizedBox(height:8),
            buildSettingsTile(
              icon: Icons.notifications_none,
              title:"Notifications ",
              onPressed:() {},
            ),

            const SizedBox(height:8),
            buildSettingsTile(
              icon: Icons.help,
              title:" Help & Support ",
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HelpSupportScreen()),
                );
              },
            ),

            const SizedBox(height:8),
            buildSettingsTile(
              icon: Icons.eco,
              title:"About HydroGrow ",
              onPressed:() {},
            ),

            const SizedBox(height:32),



          ],
        ),
      ),
    );
  }

  Widget buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,

  }){
    return GestureDetector(
      onTap:onPressed,
      child:Container(
        margin: const EdgeInsets.symmetric(vertical:6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}