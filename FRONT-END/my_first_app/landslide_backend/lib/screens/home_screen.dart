import 'package:flutter/material.dart';
import 'sensor_reading_screen.dart';
import 'package:my_first_app/screens/landslide_guide_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final date = "${now.day}/${now.month}/${now.year}";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 139, 234), // light blue
      appBar: AppBar(
        title: const Text("Landslide Alert"),
        backgroundColor: const Color.fromARGB(255, 241, 82, 82),
      ),

      /// ---------------- DRAWER ----------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 237, 61, 61)),
              child: Text(
                "Menu",
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 2, 2), fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text("Sensor Readings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SensorReadingScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text("Emergency Guide"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LandslideGuideScreen(),
                  ),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.call),
              title: Text("Emergency Numbers"),
            ),
            const ListTile(
              leading: Icon(Icons.analytics),
              title: Text("Status"),
            ),
          ],
        ),
      ),

      /// ---------------- BODY ----------------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$time • $date",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            /// -------- TOP ACTION BUTTONS --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LandslideGuideScreen(),
                      ),
                    );
                  },
                  child: topAction(Icons.warning, "Guide", Colors.orange),
                ),
                topAction(Icons.call, "Emergency", Colors.red),
                topAction(Icons.analytics, "Status", Colors.green),
              ],
            ),

            const SizedBox(height: 25),

            /// -------- STATUS SECTION --------
            const Text(
              "Current Status",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    statusRow("Soil Moisture", "Low"),
                    statusRow("Rainfall", "Moderate"),
                    statusRow("Risk Level", "Safe"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// -------- SENSOR BUTTON --------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sensors),
                label: const Text("View Sensor Readings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 76, 76),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SensorReadingScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------- WIDGETS --------

  static Widget topAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  static Widget statusRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 4, 4, 4),
            ),
          ),
        ],
      ),
    );
  }
}
