import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:grand_ball_auto/game/wall_component.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:io';
import 'ball_component.dart';
import 'light_sensor.dart';

class BallGame extends FlameGame with HasCollisionDetection {
  late BallComponent ball;
  late StreamSubscription<AccelerometerEvent> accelerometerSubscription;
  late RectangleComponent background;
  List<List<int>> walls_code = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1, 4, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  ];

  double movementFactor = 3.0; // Sensitivitas pergerakan bola
  Vector2 currentAcceleration = Vector2.zero(); // Akselerasi saat ini
  Vector2 initialOffset = Vector2.zero(); // Offset untuk kalibrasi
  Vector2 velocity = Vector2.zero(); // Kecepatan bola
  double friction = 0.98; // Koefisien gesekan (0-1)

  double ballMass = 2.0; // Massa bola (dalam satuan arbitrer)

  bool isCalibrated = false;

  final File? userPhoto;
  final bool startWithCalibration;
  final LightSensor? lightSensor;

  BallGame(
      {this.userPhoto, this.startWithCalibration = false, this.lightSensor});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Inisialisasi latar belakang
    background = RectangleComponent(
      size: Vector2(size.x, size.y),
      paint: Paint()..color = Color(0xFFFFFFFF),
    );
    add(background);

    // Tambahkan bola
    ball = BallComponent(userPhoto: userPhoto)
      ..position = Vector2(size.x / 13, size.y / 26);
    add(ball);

    double blockSize = 30.0;

    for (int i = 0; i < 26; i++) {
      for (int j = 0; j < 13; j++) {
        if (walls_code[i][j] == 1) {
          add(RectangleCollidable(Vector2(j * blockSize, i * blockSize)));
        } else if (walls_code[i][j] == 3) {
          ball.position = Vector2(j * blockSize, i * blockSize);
          add(Start(Vector2(j * blockSize, i * blockSize)));
        } else if (walls_code[i][j] == 4) {
          add(Finish(Vector2(j * blockSize, i * blockSize)));
        }
      }
    }

    if (startWithCalibration) {
      startCalibration();
    }

    // Mulai mendengarkan sensor cahaya
    lightSensor?.startListening((luxValue) {
      double opacity = lightSensor!.calculateOpacity();
      background.paint.color = Color.fromRGBO(255, 255, 255, opacity);
    });
  }

  void startCalibration() {
    print("Kalibrasi dimulai. Tetapkan posisi awal ponsel.");

    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (!isCalibrated) {
        initialOffset = Vector2(event.x, event.y);
        isCalibrated = true;
        print("Kalibrasi selesai. Titik tengah ditetapkan.");
      }

      currentAcceleration = Vector2(
        -(event.x - initialOffset.x),
        event.y - initialOffset.y,
      );
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isCalibrated) {
      Vector2 accelerationWithMass = currentAcceleration / ballMass;
      ball.velocity += accelerationWithMass * movementFactor * dt;
      ball.velocity *= friction;
      ball.move();
    }
  }

  @override
  void onRemove() {
    accelerometerSubscription.cancel();
    lightSensor?.stopListening();
    super.onRemove();
  }
}
