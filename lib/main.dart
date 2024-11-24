import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ball_game.dart';
import 'package:flame/game.dart';
import 'light_sensor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MainGameScreen(),
      ),
    );
  }
}

class MainGameScreen extends StatefulWidget {
  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  File? _userPhoto;
  LightSensor? _lightSensor;
  double _luxValue = 0.0;
  bool isLightSensorActive = false;

  // Game settings
  double _friction = 0.98;
  double _mass = 2.0;
  double _movementFactor = 3.0;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _userPhoto = File(pickedFile.path);
      });
    }
  }

  void _toggleLightSensor() {
    setState(() {
      if (isLightSensorActive) {
        _lightSensor?.stopListening();
        isLightSensorActive = false;
      } else {
        _lightSensor = LightSensor();
        _lightSensor?.startListening((luxValue) {
          setState(() {
            _luxValue = luxValue;
          });
        });
        isLightSensorActive = true;
      }
    });
  }

  double _calculateBackgroundOpacity() {
    if (!isLightSensorActive) return 1.0; // Default full brightness if sensor is off
    return _luxValue > 50 ? 1.0 : 0.0; // Set opacity based on light intensity threshold
  }

  void _startGame(BuildContext context) {
    if (_userPhoto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameWidget(
            game: BallGame(
              userPhoto: _userPhoto,
              startWithCalibration: true,
              lightSensor: _lightSensor,
            )
              ..friction = _friction
              ..ballMass = _mass
              ..movementFactor = _movementFactor,
          ),
        ),
      );
    }
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          friction: _friction,
          mass: _mass,
          movementFactor: _movementFactor,
          onSettingsChanged: (newFriction, newMass, newMovementFactor) {
            setState(() {
              _friction = newFriction;
              _mass = newMass;
              _movementFactor = newMovementFactor;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ball Game")),
      body: Stack(
        children: [
          Opacity(
            opacity: _calculateBackgroundOpacity(),
            child: Container(color: Colors.white),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Buka kamera untuk membuat avatar bolamu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _takePhoto,
                  child: Text("Buka Kamera"),
                ),
                if (_userPhoto != null)
                  ElevatedButton(
                    onPressed: () => _startGame(context),
                    child: Text("Mulai Permainan"),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _toggleLightSensor,
                  child: Text(isLightSensorActive ? "Matikan Sensor Cahaya" : "Aktifkan Sensor Cahaya"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _openSettings(context),
                  child: Text("Pengaturan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final double friction;
  final double mass;
  final double movementFactor;
  final Function(double, double, double) onSettingsChanged;

  const SettingsScreen({
    required this.friction,
    required this.mass,
    required this.movementFactor,
    required this.onSettingsChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double currentFriction;
  late double currentMass;
  late double currentMovementFactor;

  @override
  void initState() {
    super.initState();
    currentFriction = widget.friction;
    currentMass = widget.mass;
    currentMovementFactor = widget.movementFactor;
  }

  void _updateSettings() {
    widget.onSettingsChanged(currentFriction, currentMass, currentMovementFactor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Friction Slider
            Text("Friction (Gesekan): Semakin kecil, bola bergerak lebih lama"),
            Slider(
              value: currentFriction,
              min: 0.9,
              max: 1.0,
              divisions: 10,
              label: currentFriction.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  currentFriction = value;
                });
                _updateSettings();
              },
            ),
            Text("Nilai Friction: ${currentFriction.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            // Mass Slider
            Text("Mass (Massa bola): Semakin besar, bola lebih berat"),
            Slider(
              value: currentMass,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              label: currentMass.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  currentMass = value;
                });
                _updateSettings();
              },
            ),
            Text("Nilai Mass: ${currentMass.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            // Movement Factor Slider
            Text("Movement Factor: Semakin besar, bola lebih responsif"),
            Slider(
              value: currentMovementFactor,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              label: currentMovementFactor.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  currentMovementFactor = value;
                });
                _updateSettings();
              },
            ),
            Text("Nilai Movement Factor: ${currentMovementFactor.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

