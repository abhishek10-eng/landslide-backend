#include <WiFi.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

const char* ssid = "ANJALI";
const char* password = "radha2025";

const char* server = "https://landslide-backend-7by2.onrender.com/update-sensor";

int soilPin = 34;

int dryValue = 3270;
int wetValue = 1400;

void setup() {

  Serial.begin(115200);

  // WiFi connection
  WiFi.begin(ssid, password);

  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println(" Connected!");

  Serial.print("ESP32 IP: ");
  Serial.println(WiFi.localIP());

  // I2C start (MPU6050)
  Wire.begin(21, 22);

  mpu.initialize();

  if (mpu.testConnection()) {
    Serial.println("MPU6050 connected");
  } else {
    Serial.println("MPU6050 connection failed");
  }
}

void loop() {

  // -------- Soil Moisture --------
  int soilValue = analogRead(soilPin);

  int moisturePercent = map(soilValue, dryValue, wetValue, 0, 100);
  moisturePercent = constrain(moisturePercent, 0, 100);

  Serial.print("Moisture: ");
  Serial.print(moisturePercent);
  Serial.println("%");

  // -------- MPU6050 --------
  int16_t ax, ay, az;
  mpu.getAcceleration(&ax, &ay, &az);

  float ax_f = ax;
  float ay_f = ay;
  float az_f = az;
  
  Serial.print("AX: ");
  Serial.print(ax_f);
  Serial.print(" AY: ");
  Serial.print(ay_f);
  Serial.print(" AZ: ");
  Serial.println(az_f);
  

  int vibration = abs(ax) + abs(ay) + abs(az);

  float tiltAngle = atan2(ay, az) * 180 / PI;

  if (abs(tiltAngle) < 2) {
  tiltAngle = 0;
  }

 
  Serial.print("Tilt Angle: ");
  Serial.println(tiltAngle);
  Serial.println("------");
  // -------- Send Data to Backend --------
  WiFiClientSecure client;
  client.setInsecure();
  
  HTTPClient http;

  if (http.begin(client, server)) {

    http.addHeader("Content-Type", "application/json");

    String json = "{";
    json += "\"soilMoisture\":" + String(moisturePercent) + ",";
    json += "\"vibration\":" + String(vibration) + ",";
    json += "\"tiltAngle\":" + String(tiltAngle) + ",";
    json += "\"rainfall\":0";
    json += "}";

    Serial.println("Sending JSON:");
    Serial.println(json);

    int httpResponseCode = http.POST(json);

    Serial.print("HTTP Response: ");
    Serial.println(httpResponseCode);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(response);
    }

    http.end();
  }

  delay(5000);
}