import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'ball_game.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BallGameScreen(),
      ),
    );
  }
}

class BallGameScreen extends StatefulWidget {
  @override
  _BallGameScreenState createState() => _BallGameScreenState();
}

class _BallGameScreenState extends State<BallGameScreen> {
  late BallGame _ballGame;
  bool isCalibrating = true;
  String message = "Tentukan posisi terbaikmu, lalu ketuk layar untuk kalibrasi";
  int countdown = 3;

  @override
  void initState() {
    super.initState();
    _ballGame = BallGame();
  }

  void startCalibration() {
    // Ubah pesan menjadi countdown
    setState(() {
      message = "Kalibrasi dimulai dalam $countdown...";
    });

    // Mulai countdown
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown > 0) {
          message = "Kalibrasi dimulai dalam $countdown...";
        } else {
          // Selesai kalibrasi, mulai game
          message = "Kalibrasi selesai!";
          isCalibrating = false;
          _ballGame.startCalibration(); // Memulai kalibrasi di dalam game
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isCalibrating) startCalibration(); // Mulai kalibrasi saat layar diketuk
      },
      child: Stack(
        children: [
          GameWidget(game: _ballGame),
          if (isCalibrating)
            Container(
              color: Colors.black54,
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
