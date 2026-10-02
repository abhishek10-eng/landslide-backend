import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://landslide-backend-7by2.onrender.com";
  static String? token;

  // ---------------- LOGIN ----------------
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data["token"];
      return true;
    }

    return false;
  }

  // ---------------- FETCH SENSOR DATA ----------------
  static Future<Map<String, dynamic>> fetchSensorData() async {
    if (token == null) {
      throw Exception("Auth token missing");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/sensor-data"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body); // ADD THIS
    if (response.statusCode != 200) {
      throw Exception("Unauthorized or server error");
    }

    return jsonDecode(response.body);
  }

  // ---------------- SIMULATE LANDSLIDE ----------------
  static Future<void> simulateLandslide() async {
    if (token == null) {
      throw Exception("Auth token missing");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/simulate-landslide"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to simulate landslide");
    }
  }
}
