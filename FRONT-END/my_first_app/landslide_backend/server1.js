const express = require("express");
const jwt = require("jsonwebtoken");

const app = express();
const JWT_SECRET = "landslide_secret_key";

// Middleware
app.use(express.json());

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

// ---------------- HOME ----------------
app.get("/", (req, res) => {
  res.json({ message: "Landslide Backend Running 🚀" });
});

// ---------------- LOGIN ----------------
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  const user = users.find(
    u => u.username === username && u.password === password
  );

  if (!user) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const token = jwt.sign(
    { username: user.username, role: user.role },
    JWT_SECRET,
    { expiresIn: "1h" }
  );

  res.json({
    message: "Login successful",
    token: token
  });
});

// ---------------- SENSOR DATA ----------------
app.get("/sensor-data", (req, res) => {
  res.json(sensorData);
});

// ---------------- SIMULATE LANDSLIDE ----------------
app.post("/simulate-landslide", (req, res) => {
  const user = verifyToken(req);

  if (!user) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  sensorData = {
    soilMoisture: 90,
    vibration: 6.5,
    tiltAngle: 18,
    rainfall: 85,
    status: "DANGER"
  };

  res.json(sensorData);
});

// ---------------- START ----------------
app.listen(4000, () => {
  console.log("Backend running at http://localhost:4000");
});
