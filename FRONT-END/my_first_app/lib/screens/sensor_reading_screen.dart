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

  double moistureThreshold = 70; // change if needed
  double tiltThreshold = 3.5; // change if needed

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

    if (!mounted) return;

    setState(() {
      data = SensorData.fromJson(newData);
    });

    checkDangerCondition();
  }

  // 🔹 Auto refresh every 5 seconds
  void startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final newData = await ApiService.fetchSensorData();

      if (!mounted) return;

      setState(() {
        data = SensorData.fromJson(newData);
      });

      checkDangerCondition();
    });
  }

  // 🔹 Simulate landslide via backend
  void simulateLandslide() async {
    _timer?.cancel();

    await ApiService.simulateLandslide();
    final newData = await ApiService.fetchSensorData();

    if (!mounted) return;

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
    String status = getStatus();

    if (status == "DANGER") return Colors.red;
    if (status == "MOISTURE HIGH") return Colors.orange;
    if (status == "TILT HIGH") return Colors.orange;

    return Colors.green;
  }

  bool isDanger() {
    if (data == null) return false;

    return data!.soilMoisture > moistureThreshold &&
        data!.tiltAngle.abs() > tiltThreshold;
  }

  String getStatus() {
    bool moistureHigh = data!.soilMoisture > moistureThreshold;
    bool tiltHigh = data!.tiltAngle.abs() > tiltThreshold;

    if (moistureHigh && tiltHigh) {
      return "DANGER";
    }

    if (moistureHigh) {
      return "MOISTURE HIGH";
    }

    if (tiltHigh) {
      return "TILT HIGH";
    }

    return "SAFE";
  }

  void checkDangerCondition() {
    if (isDanger()) {
      if (!_alertShown) {
        _alertShown = true;

        _blinkController.repeat(reverse: true);

        showDangerDialog();
      }
    } else {
      // Reset alert when system becomes safe
      _alertShown = false;
      _blinkController.stop();
    }
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
        backgroundColor: isDanger() ? _blinkAnimation.value : statusColor(),
      ),
      body: AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Container(
            color: isDanger() ? Colors.red.shade50 : Colors.white,
            padding: const EdgeInsets.all(16),
            child: child,
          );
        },
        child: Column(
          children: [
            infoTile("Soil Moisture", "${data!.soilMoisture}%"),
            const SizedBox(height: 10),
            const Text(
              "Tilt Sensor",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            infoTile("Tilt Angle", "${data!.tiltAngle}°"),
            infoTile("Vibration", data!.vibration.toString()),
            infoTile("Rainfall", "${data!.rainfall} mm"),
            const SizedBox(height: 20),
            Text(
              "Status: ${getStatus()}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: statusColor(),
              ),
            ),
            const SizedBox(height: 30),
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

Widget expandedTile(String title, String value) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
