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
      ..position = Vector2(size.x / 2, size.y / 2);
    add(ball);

    double blockSizeX = size.x / 12; // Menyesuaikan ukuran blok dengan lebar layar dan jumlah kolom (13)
    double blockSizeY = size.y / 24; // Menyesuaikan ukuran blok dengan tinggi layar dan jumlah baris (26)

    // Gunakan ukuran terkecil dari lebar dan tinggi
    double blockSize = blockSizeX < blockSizeY ? blockSizeX : blockSizeY;

    for (int i = 0; i < 26; i++) {
      for (int j = 0; j < 13; j++) {
        if (walls_code[i][j] == 1) {
          add(RectangleCollidable(Vector2(j * blockSize, i * blockSize)));
        } else if (walls_code[i][j] == 3) {
          final startPosition = Vector2(j * blockSize, i * blockSize);
          ball.position = startPosition; // Set the ball position to the start
          add(Start(startPosition));
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
      double opacity = calculateOpacityFromLux(luxValue);
      // Set warna latar belakang berdasarkan nilai lux
      background.paint.color = Color.fromRGBO(255, 255, 255, opacity); // Mengubah opacity background
    });
  }

  double calculateOpacityFromLux(double luxValue) {
    // Asumsikan nilai lux berada pada kisaran yang umum. Sesuaikan dengan kebutuhan.
    double minLux = 0;    // Nilai lux minimum (gelap)
    double maxLux = 200; // Nilai lux maksimum (terang)

    // Normalisasi nilai lux menjadi antara 0 dan 1
    double normalizedLux = (luxValue - minLux) / (maxLux - minLux);
    normalizedLux = normalizedLux.clamp(0.0, 1.0); // Pastikan nilainya antara 0 dan 1

    // Konversi nilai lux menjadi opacity (0 = hitam, 1 = putih)
    return 1.0 - normalizedLux; // Jika cahaya terang (lux tinggi), opacity lebih dekat ke 0 (putih)
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
