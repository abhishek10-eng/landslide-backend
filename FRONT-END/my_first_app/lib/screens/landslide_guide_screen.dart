import 'package:flutter/material.dart';

class LandslideGuideScreen extends StatelessWidget {
  const LandslideGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landslide Safety Guide"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            GuideTile(
              title: "⚠️ Before Landslide",
              points: [
                "Stay alert during heavy rainfall",
                "Avoid steep slopes and hilly areas",
                "Keep emergency contacts ready",
                "Prepare emergency kit (water, torch, phone)",
              ],
            ),
            GuideTile(
              title: "🚨 During Landslide",
              points: [
                "Move to higher ground immediately",
                "Do not cross flowing debris",
                "Avoid rivers and valleys",
                "Follow local authority warnings",
              ],
            ),
            GuideTile(
              title: "✅ After Landslide",
              points: [
                "Avoid damaged areas",
                "Help injured people",
                "Check for gas or water leakage",
                "Wait for official clearance",
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GuideTile extends StatelessWidget {
  final String title;
  final List<String> points;

  const GuideTile({super.key, required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...points.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("• $p"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
