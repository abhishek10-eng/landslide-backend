import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_first_app/models/sensor_data.dart';
import 'package:my_first_app/services/api_service.dart';

class SensorReadingScreen extends StatefulWidget {
  const SensorReadingScreen({super.key});

  @override
  State<SensorReadingScreen> createState() => _SensorReadingScreenState();
}

class _SensorReadingScreenState extends State<SensorReadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<Color?> _blinkAnimation;
  bool _alertShown = false;

  SensorData? data;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _blinkAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.red.shade200,
    ).animate(_blinkController);

    loadInitialData();
    startAutoRefresh();
  }

  // 🔹 Load first data from backend
  void loadInitialData() async {
    final newData = await ApiService.fetchSensorData();
    setState(() {
      data = SensorData.fromJson(newData);
    });
  }

  // 🔹 Auto refresh every 5 seconds
  void startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final newData = await ApiService.fetchSensorData();
      setState(() {
        data = SensorData.fromJson(newData);
      });
    });
  }

  // 🔹 Simulate landslide via backend
  void simulateLandslide() async {
    _timer?.cancel();

    await ApiService.simulateLandslide();
    final newData = await ApiService.fetchSensorData();

    setState(() {
      data = SensorData.fromJson(newData);
    });

    _blinkController.repeat(reverse: true);

    if (!_alertShown) {
      _alertShown = true;
      showDangerDialog();
    }
  }

  void showDangerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: const Text(
            "⚠️ LANDSLIDE ALERT",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Critical sensor values detected.\n\n"
            "Immediate action required!\n"
            "Please evacuate the area.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("ACKNOWLEDGE"),
            ),
          ],
        );
      },
    );
  }

  Color statusColor() {
    if (data!.status.contains("DANGER")) return Colors.red;
    return Colors.green;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Readings"),
        backgroundColor: data!.status.contains("DANGER")
            ? _blinkAnimation.value
            : Colors.green,
      ),
      body: AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Container(
            color: data!.status.contains("DANGER")
                ? Colors.red.shade50
                : Colors.white,
            padding: const EdgeInsets.all(16),
            child: child,
          );
        },
        child: Column(
          children: [
            infoTile("Soil Moisture", "${data!.soilMoisture}%"),
            infoTile("Vibration", data!.vibration.toString()),
            infoTile("Tilt Angle", "${data!.tiltAngle}°"),
            infoTile("Rainfall", "${data!.rainfall} mm"),
            const SizedBox(height: 20),
            Text(
              "Status: ${data!.status}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: statusColor(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: simulateLandslide,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Simulate Landslide"),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
