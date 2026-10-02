import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController controller = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    messages.add({
      "sender": "bot",
      "text":
          "👋 Hello! I am your Landslide Safety Assistant.\n\nAsk me anything about landslides, safety, sensors, or emergency situations."
    });
  }

  /// 🔥 ADVANCED SMART BOT
  String getBotResponse(String msg) {
    msg = msg.toLowerCase();

    /// GREETING
    if (msg.contains("hi") || msg.contains("hello")) {
      return "👋 Hello! How can I assist you regarding landslide safety?";
    }

    /// LAND MOVING
    if (msg.contains("land moving") || msg.contains("ground moving")) {
      return "🚨 Ground movement detected!\n\n👉 Move away immediately\n👉 Avoid slopes\n👉 Alert others nearby\n👉 Use SOS button if needed";
    }

    /// WATER LEVEL HIGH
    if (msg.contains("water level") || msg.contains("flood")) {
      return "🌊 High water level warning!\n\n👉 Move to higher ground\n👉 Avoid river sides\n👉 Stay away from slopes\n👉 Keep emergency kit ready";
    }

    /// NEED SAFE LOCATION
    if (msg.contains("safe location") || msg.contains("where to go")) {
      return "🏠 Move to a safer location:\n\n• Flat ground\n• Away from hills/slopes\n• Open safe zones\n• Government shelters if available";
    }

    /// SENSOR DAMAGE
    if (msg.contains("sensor damaged") || msg.contains("sensor not working")) {
      return "⚠️ Sensor issue detected!\n\n👉 Check connections\n👉 Restart system\n👉 Use manual monitoring\n👉 Inform technical team";
    }

    /// WHAT TO DO
    if (msg.contains("what should i do")) {
      return "👉 Stay calm\n👉 Move to safe place\n👉 Avoid slopes\n👉 Follow alerts\n👉 Use SOS if needed";
    }

    /// CAUSES
    if (msg.contains("cause")) {
      return "⚠️ Causes of landslides:\n\n• Heavy rainfall 🌧\n• Soil saturation 💧\n• Earthquakes 🌎\n• Deforestation\n• Construction";
    }

    /// WARNING SIGNS
    if (msg.contains("sign") || msg.contains("crack")) {
      return "⚠️ Warning signs:\n\n• Ground cracks\n• Tilting trees\n• Sudden water flow\n• Strange sounds";
    }

    /// DANGER
    if (msg.contains("danger") || msg.contains("risk")) {
      return "🚨 High Risk!\n\n👉 Move away immediately\n👉 Avoid valleys\n👉 Stay alert";
    }

    /// SAFE
    if (msg.contains("safe")) {
      return "✅ Area is currently safe.\n\nContinue monitoring sensor readings.";
    }

    /// EMERGENCY HELP
    if (msg.contains("help") ||
        msg.contains("emergency") ||
        msg.contains("sos")) {
      return "📞 Emergency steps:\n\n1. Press SOS\n2. Move to safe area\n3. Inform authorities\n4. Avoid danger zones";
    }

    /// RAIN
    if (msg.contains("rain")) {
      return "🌧 Heavy rainfall increases landslide risk significantly.";
    }

    /// MOISTURE
    if (msg.contains("moisture") || msg.contains("soil")) {
      return "💧 High soil moisture weakens ground stability.";
    }

    /// TILT
    if (msg.contains("tilt")) {
      return "📐 Tilt increase means ground movement — possible landslide!";
    }

    /// SENSOR
    if (msg.contains("sensor")) {
      return "📡 Sensors monitor:\n\n• Soil moisture\n• Ground tilt\n\nThey help detect landslides early.";
    }

    /// DEFAULT
    return "🤖 I can help with landslide safety, risks, sensors, and emergency situations.\n\nTry asking:\n• land moving\n• water level high\n• precautions\n• help\n• sensors";
  }

  /// SEND MESSAGE
  Future<void> sendMessage() async {
    String userMsg = controller.text.trim();
    if (userMsg.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": userMsg});
      messages.add({"sender": "bot", "text": "Typing..."});
    });

    controller.clear();

    await Future.delayed(const Duration(milliseconds: 500));

    String reply = getBotResponse(userMsg);

    setState(() {
      messages.removeLast();
      messages.add({"sender": "bot", "text": reply});
    });
  }

  /// QUICK BUTTON
  Widget quickButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () async {
        setState(() {
          messages.add({"sender": "user", "text": text});
          messages.add({"sender": "bot", "text": "Typing..."});
        });

        await Future.delayed(const Duration(milliseconds: 500));

        String reply = getBotResponse(text);

        setState(() {
          messages.removeLast();
          messages.add({"sender": "bot", "text": reply});
        });
      },
      child: Text(text),
    );
  }

  /// CHAT UI
  Widget buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.red : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chatbot")),
      body: Column(
        children: [
          /// QUICK BUTTONS
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              children: [
                quickButton("Land moving"),
                quickButton("Water level high"),
                quickButton("Danger"),
                quickButton("Help"),
                quickButton("Sensors"),
              ],
            ),
          ),

          /// CHAT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: messages
                  .map((msg) => buildMessage(
                        msg["text"]!,
                        msg["sender"] == "user",
                      ))
                  .toList(),
            ),
          ),

          /// INPUT
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Ask about landslides...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
