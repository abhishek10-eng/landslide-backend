class SensorData {
  final int soilMoisture;
  final double vibration;
  final int tiltAngle;
  final int rainfall;
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
      soilMoisture: json['soilMoisture'],
      vibration: (json['vibration'] as num).toDouble(),
      tiltAngle: json['tiltAngle'],
      rainfall: json['rainfall'],
      status: json['status'],
    );
  }
}
