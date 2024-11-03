import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ball_game.dart';
import 'package:flame/game.dart';

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

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _userPhoto = File(pickedFile.path);
      });
    }
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
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Tentukan posisi ternyamanmu, kalibrasi dilakukan otomatis saat memulai permainan",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
