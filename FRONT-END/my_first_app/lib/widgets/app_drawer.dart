import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// 🔴 HEADER
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? const LinearGradient(
                      colors: [Colors.black, Colors.grey],
                    )
                  : const LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'DisasterForecast',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Stay Alert. Stay Safe.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// 🌙 DARK MODE SWITCH
          SwitchListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: isDarkMode,
            activeColor: Colors.redAccent,
            onChanged: (val) => onToggle(val),
          ),

          /// HOME
          ListTile(
            leading: Icon(Icons.home,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              'Home',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          /// SENSOR
          ListTile(
            leading: Icon(Icons.sensors,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              'Sensor Readings',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sensors');
            },
          ),

          /// GUIDE
          ListTile(
            leading: Icon(Icons.warning,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              'Emergency Guide',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          /// CONTACT
          ListTile(
            leading: Icon(Icons.call,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              'Emergency Numbers',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          /// LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
