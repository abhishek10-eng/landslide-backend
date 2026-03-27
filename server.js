const http = require("http");

console.log("🔥 NEW BACKEND DEPLOYED (NO AUTH) 🔥");

// ---------------- DATA ----------------
let sensorData = {
  soilMoisture: 55,
  vibration: 2.1,
  tiltAngle: 5,
  rainfall: 20,
  status: "SAFE"
};

// ---------------- SERVER ----------------
const server = http.createServer((req, res) => {

  // CORS
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

  if (req.method === "OPTIONS") {
    res.writeHead(200);
    res.end();
    return;
  }

  // ---------- ROOT ----------
  if (req.url === "/" && req.method === "GET") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("Landslide backend is running 🚀");
    return;
  }

  // ---------- RECEIVE SENSOR DATA FROM ESP32 ----------
  if (req.url === "/update-sensor" && req.method === "POST") {
    let body = "";

    req.on("data", chunk => {
      body += chunk.toString();
    });

    req.on("end", () => {
      try {
        const data = JSON.parse(body);

        sensorData = {
          soilMoisture: data.soilMoisture,
          vibration: data.vibration,
          tiltAngle: data.tiltAngle,
          rainfall: data.rainfall || 0,
          status: "SAFE"
        };

        console.log("📡 Data received:", sensorData);

        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Data updated" }));

      } catch (err) {
        res.writeHead(400, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Invalid JSON" }));
      }
    });

    return;
  }

  // ---------- SENSOR DATA ----------
  if (req.url === "/sensor-data" && req.method === "GET") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify(sensorData));
    return;
  }

  // ---------- SIMULATE LANDSLIDE ----------
  if (req.url === "/simulate-landslide" && req.method === "POST") {

    sensorData = {
      soilMoisture: 90,
      vibration: 6.5,
      tiltAngle: 18,
      rainfall: 85,
      status: "DANGER"
    };

    console.log("⚠️ Landslide simulated!");

    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify(sensorData));
    return;
  }

  // ---------- DEFAULT ----------
  res.writeHead(404);
  res.end("Not Found");
});

// ---------------- START ----------------
const PORT = process.env.PORT || 5000;

server.listen(PORT, "0.0.0.0", () => {
  console.log("Backend running on port " + PORT);
});
