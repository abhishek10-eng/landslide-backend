const http = require("http");
const jwt = require("jsonwebtoken");

const JWT_SECRET = "landslide_secret_key";

// ---------------- DATA ----------------
let sensorData = {
  soilMoisture: 55,
  vibration: 2.1,
  tiltAngle: 5,
  rainfall: 20,
  status: "SAFE"
};

const users = [
  { username: "admin", password: "admin123", role: "admin" },
  { username: "user", password: "user123", role: "user" }
];

// ---------------- AUTH ----------------
function verifyToken(req) {
  const authHeader = req.headers["authorization"];
  if (!authHeader) return null;

  const token = authHeader.split(" ")[1];
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (err) {
    return null;
  }
}

// ---------------- SERVER ----------------
const server = http.createServer((req, res) => {
  // CORS
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Content-Type, Authorization"
  );
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

  if (req.method === "OPTIONS") {
    res.writeHead(200);
    res.end();
    return;
  }
  // ---------- ROOT ----------
if (req.url === "/" && req.method === "GET") {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("ESP32 cloud backend is running");
  return;
}
// ---------- RECEIVE SENSOR DATA FROM ESP32 ----------
if (req.url === "/update-sensor" && req.method === "POST") {
  let body = "";

  req.on("data", chunk => {
    body += chunk.toString();
  });

  req.on("end", () => {
    const data = JSON.parse(body);

    sensorData = {
      soilMoisture: data.soilMoisture,
      vibration: data.vibration,
      tiltAngle: data.tiltAngle,
      rainfall: data.rainfall || 0,
      status: "SAFE"
    };

    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ message: "Data updated" }));
  });

  return;
}
  // ---------- LOGIN ----------
  if (req.url === "/login" && req.method === "POST") {
    let body = "";

    req.on("data", chunk => {
      body += chunk.toString();
    });

    req.on("end", () => {
      const { username, password } = JSON.parse(body);

      const user = users.find(
        u => u.username === username && u.password === password
      );

      if (!user) {
        res.writeHead(401, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Invalid credentials" }));
        return;
      }

      const token = jwt.sign(
        { username: user.username, role: user.role },
        JWT_SECRET,
        { expiresIn: "1h" }
      );

      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({
        message: "Login successful",
        token: token
      }));
    });

    return;
  }

  // ---------- SENSOR DATA ----------
  if (req.url === "/sensor-data" && req.method === "GET") {
    const user = verifyToken(req);

    if (!user) {
      res.writeHead(401, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ message: "Unauthorized" }));
      return;
    }

    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify(sensorData));
    return;
  }

  // ---------- SIMULATE LANDSLIDE ----------
  if (req.url === "/simulate-landslide" && req.method === "POST") {
    const user = verifyToken(req);

    if (!user) {
      res.writeHead(401, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ message: "Unauthorized" }));
      return;
    }

    sensorData = {
      soilMoisture: 90,
      vibration: 6.5,
      tiltAngle: 18,
      rainfall: 85,
      status: "DANGER"
    };

    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify(sensorData));
    return;
  }

  // ---------- DEFAULT ----------
  res.writeHead(404);
  res.end("Not Found");
});

// ---------------- START ----------------
server.listen(5000, "0.0.0.0", () => {
  console.log("Backend running on port 5000");
});


