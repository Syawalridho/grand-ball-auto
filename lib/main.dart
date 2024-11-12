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

  void _startGame(BuildContext context) {
    if (_userPhoto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameWidget(
            game: BallGame(
              userPhoto: _userPhoto,
              startWithCalibration: true,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ball Game")),
      body: Stack(
        children: [
          // Adjust background opacity based on light sensor reading
          Opacity(
            opacity: _lightSensor?.calculateOpacity() ?? 1.0,
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
                if (isLightSensorActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Intensity of Light (Lux): ${_luxValue.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
