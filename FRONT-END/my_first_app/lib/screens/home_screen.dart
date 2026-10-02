import 'package:flutter/material.dart';
import 'sensor_reading_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chatbot_screen.dart';
import 'graph_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  bool isNotified = false;
  bool isDarkMode = false;

  double moistureThreshold = 50;
  double tiltThreshold = 3;

  double moisture = 0;
  double tilt = 0;

  /// 🔥 FIXED EMERGENCY FUNCTION
  void callEmergency() async {
    final Uri phone = Uri(scheme: 'tel', path: '100');

    if (await canLaunchUrl(phone)) {
      await launchUrl(
        phone,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print("Cannot open dialer");
    }
  }

  Future<void> showDangerNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'landslide_channel_id',
      'Landslide Alerts',
      channelDescription: 'Landslide detection alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      "⚠️ Landslide Warning",
      "Danger detected!",
      details,
    );
  }

  void startMonitoring() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final response = await http.get(
          Uri.parse("https://landslide-backend-7by2.onrender.com/sensor-data"),
        );

        final data = jsonDecode(response.body);

        setState(() {
          moisture = (data['soilMoisture'] ?? 0).toDouble();
          tilt = (data['tiltAngle'] ?? 0).toDouble().abs();
        });

        bool isDanger = moisture > moistureThreshold && tilt > tiltThreshold;

        if (isDanger && !isNotified) {
          await showDangerNotification();
          isNotified = true;
        } else if (!isDanger) {
          isNotified = false;
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startMonitoring();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool get isDanger => moisture > moistureThreshold && tilt > tiltThreshold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      const Text(
                        "LANDSLIDE ALERT",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Real-time Monitoring System",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            /// ALERT
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDanger ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isDanger
                          ? "Danger detected! Evacuate immediately!"
                          : "All conditions normal. You are safe.",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            /// SOS
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(40),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    callEmergency();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("🚨 SOS Activated"),
                          content: const Text(
                              "Emergency call triggered!\nMove to a safe location."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("SOS",
                      style: TextStyle(fontSize: 28, color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text("Tap for help",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black)),
              ],
            ),

            const SizedBox(height: 20),

            /// SENSOR CARDS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  sensorCard("Moisture", "$moisture %", Icons.opacity),
                  sensorCard("Tilt", "$tilt °", Icons.show_chart),
                  sensorCard(
                      "Status", isDanger ? "Danger" : "Safe", Icons.warning),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButton(Icons.cloud, "Weather", showWeather),
                buildButton(Icons.call, "Emergency", callEmergency),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showWeather() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("🌧 Weather Info"),
          content:
              const Text("Rainfall: High\nHumidity: 80%\nTemperature: 27°C"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget buildButton(IconData icon, String text, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
    );
  }

  Widget sensorCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, color: Colors.redAccent),
              const SizedBox(height: 8),
              Text(title,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54)),
              Text(value,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      child: ListView(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? const LinearGradient(
                      colors: [Colors.black, Colors.grey],
                    )
                  : const LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                    ),
            ),
            child: const Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          SwitchListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.show_chart,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              "Graph",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GraphScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.chat,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              "Chatbot",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatbotScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.sensors,
                color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              "Sensor Data",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SensorReadingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
