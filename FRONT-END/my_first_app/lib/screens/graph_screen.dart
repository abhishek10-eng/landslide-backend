import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<FlSpot> moistureData = [];
  List<FlSpot> tiltData = [];

  int time = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startFetching();
  }

  void startFetching() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final response = await http.get(
        Uri.parse("https://landslide-backend-7by2.onrender.com/sensor-data"),
      );

      final data = jsonDecode(response.body);

      double moisture = (data['soilMoisture'] ?? 0).toDouble();
      double tilt = (data['tiltAngle'] ?? 0).toDouble();

      setState(() {
        moistureData.add(FlSpot(time.toDouble(), moisture));
        tiltData.add(FlSpot(time.toDouble(), tilt));

        time++;

        if (moistureData.length > 10) {
          moistureData.removeAt(0);
          tiltData.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor Graph")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: moistureData,
                isCurved: true,
              ),
              LineChartBarData(
                spots: tiltData,
                isCurved: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
