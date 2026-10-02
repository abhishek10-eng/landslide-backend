class SensorData {
  final double soilMoisture;
  final double vibration;
  final double tiltAngle;
  final double rainfall;
  final String status;

  SensorData({
    required this.soilMoisture,
    required this.vibration,
    required this.tiltAngle,
    required this.rainfall,
    required this.status,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      soilMoisture: (json['soilMoisture'] ?? 0).toDouble(),
      vibration: (json['vibration'] ?? 0).toDouble(),
      tiltAngle: (json['tiltAngle'] ?? 0).toDouble(),
      rainfall: (json['rainfall'] ?? 0).toDouble(),
      status: json['status'] ?? "SAFE",
    );
  }
}
