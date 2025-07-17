import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrogrow_fixed/help_and_support.dart';
import 'package:hydrogrow_fixed/login.dart';
import 'package:hydrogrow_fixed/lights.dart';
import 'package:hydrogrow_fixed/alerts.dart';
import 'package:hydrogrow_fixed/settings.dart';
import 'package:hydrogrow_fixed/threshold.dart';
import 'package:hydrogrow_fixed/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPage = 0;
  bool showThresholdFromAlerts = false;
  bool showProfileFromSettings = false;
  bool showHelpFromSettings = false;

  late final List<Widget> _pages;

  final List<String> _titles = [
    'Dashboard',
    'Lights',
    'Alerts',
    'Settings',
    'Configure Thresholds',
    'Profile',
    'Help and Support',
  ];

  User? currentUser;

  @override
  void initState() {
    super.initState();

    // Get current user once on init
    currentUser = FirebaseAuth.instance.currentUser;

    _pages = [
      const DashboardContent(),
      const LightsPage(),
      const SizedBox.shrink(), // Alerts handled separately
      SettingsPage(
        onNavigateToProfile: () {
          setState(() {
            currentPage = 5;
            showProfileFromSettings = true;
            showHelpFromSettings = false;
          });
        },
        onNavigateToHelp: () {
          setState(() {
            currentPage = 6;
            showHelpFromSettings = true;
            showProfileFromSettings = false;
          });
        },
      ),
      const ThresholdPage(),
      const ProfilePage(),
      const HelpSupportScreen(),
    ];
  }

  Widget getPageForCurrentIndex() {
    if (currentPage == 2) {
      if (showThresholdFromAlerts) {
        return const ThresholdPage();
      } else {
        return AlertsPage(
          onNavigateToThreshold: () {
            setState(() {
              showThresholdFromAlerts = true;
              currentPage = 2;
            });
          },
        );
      }
    } else if (currentPage == 3) {
      if (showProfileFromSettings) {
        return const ProfilePage();
      } else if (showHelpFromSettings) {
        return const HelpSupportScreen();
      } else {
        return SettingsPage(
          onNavigateToProfile: () {
            setState(() {
              currentPage = 5;
              showProfileFromSettings = true;
              showHelpFromSettings = false;
            });
          },
          onNavigateToHelp: () {
            setState(() {
              currentPage = 6;
              showHelpFromSettings = true;
              showProfileFromSettings = false;
            });
          },
        );
      }
    } else {
      if (currentPage != 2) showThresholdFromAlerts = false;
      if (currentPage != 3 && currentPage != 5) showProfileFromSettings = false;
      if (currentPage != 3 && currentPage != 6) showHelpFromSettings = false;
      return _pages[currentPage];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (currentPage == 2 && showThresholdFromAlerts) ||
            (currentPage == 5 && showProfileFromSettings) ||
            (currentPage == 6 && showHelpFromSettings)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              if (currentPage == 2 && showThresholdFromAlerts) {
                showThresholdFromAlerts = false;
              } else if (currentPage == 5 && showProfileFromSettings) {
                currentPage = 3;
                showProfileFromSettings = false;
              } else if (currentPage == 6 && showHelpFromSettings) {
                currentPage = 3;
                showHelpFromSettings = false;
              }
            });
          },
        )
            : Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          (currentPage == 2 && showThresholdFromAlerts)
              ? 'Thresholds'
              : (currentPage == 5 && showProfileFromSettings)
              ? 'Profile'
              : (currentPage == 6 && showHelpFromSettings)
              ? 'Help and Support'
              : _titles[currentPage],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(''),
              accountEmail: Text(currentUser?.email ?? 'No Email'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (currentUser?.email != null && currentUser!.email!.isNotEmpty)
                      ? currentUser!.email![0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: const BoxDecoration(color: Colors.green),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                setState(() {
                  currentPage = 0;
                  showThresholdFromAlerts = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Lights'),
              onTap: () {
                setState(() {
                  currentPage = 1;
                  showThresholdFromAlerts = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Alerts'),
              trailing: const Icon(Icons.notifications_none),
              onTap: () {
                setState(() {
                  currentPage = 2;
                  showThresholdFromAlerts = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  currentPage = 3;
                  showThresholdFromAlerts = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Configure Thresholds'),
              onTap: () {
                setState(() {
                  currentPage = 4;
                  showThresholdFromAlerts = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                setState(() {
                  currentPage = 5;
                  showProfileFromSettings = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Help and Support'),
              onTap: () {
                setState(() {
                  currentPage = 6;
                  showThresholdFromAlerts = false;
                  showProfileFromSettings = false;
                  showHelpFromSettings = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut(); // ✅ Sign out user
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: getPageForCurrentIndex(),
      bottomNavigationBar: (currentPage <= 4 || (currentPage == 5 && showProfileFromSettings))
          ? NavigationBar(
        selectedIndex: currentPage > 3 ? 3 : currentPage,
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
            showThresholdFromAlerts = false;
            showProfileFromSettings = false;
            showHelpFromSettings = false;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.light_mode),
            label: 'Lights',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      )
          : null,
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  Widget myRoundedBox({required IconData icon, required String label}) {
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6FA),
      child: Padding(
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
                    myRoundedBox(
                      icon: Icons.water_drop_outlined,
                      label: "Soil Moisture",
                    ),
                    myRoundedBox(
                      icon: Icons.thermostat_outlined,
                      label: "Air Temperature",
                    ),
                    myRoundedBox(
                      icon: Icons.air_outlined,
                      label: "Air Humidity",
                    ),
                    myRoundedBox(
                      icon: Icons.light_mode_outlined,
                      label: "Ambient Light Intensity",
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
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
      ),
    );
  }
}
