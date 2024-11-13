import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'ball_component.dart';
import 'light_sensor.dart';

class BallGame extends FlameGame {
  late BallComponent ball;
  late StreamSubscription<AccelerometerEvent> accelerometerSubscription;
  late RectangleComponent background; // Komponen latar belakang

  final double movementFactor = 3.0;
  Vector2 currentAcceleration = Vector2.zero();
  Vector2 initialOffset = Vector2.zero();
  bool isCalibrated = false;

  final File? userPhoto;
  final bool startWithCalibration;
  final LightSensor? lightSensor; // Tambahkan parameter lightSensor

  BallGame({this.userPhoto, this.startWithCalibration = false, this.lightSensor});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Inisialisasi komponen latar belakang
    background = RectangleComponent(
      size: Vector2(size.x, size.y),
      paint: Paint()..color = Color(0xFFFFFFFF), // Mulai dengan warna putih
    );
    add(background);

    // Tambahkan komponen bola ke game, dengan foto pengguna jika tersedia
    ball = BallComponent(userPhoto: userPhoto)
      ..position = Vector2(size.x / 2, size.y / 2);
    add(ball);

    if (startWithCalibration) {
      startCalibration(); // Mulai kalibrasi otomatis jika diperlukan
    }

    // Mulai mendengarkan perubahan intensitas cahaya jika sensor diaktifkan
    lightSensor?.startListening((luxValue) {
      // Ubah opasitas warna latar belakang secara bertahap
      double opacity = lightSensor!.calculateOpacity();
      background.paint.color = Color.fromRGBO(255, 255, 255, opacity); // Gradual dari putih ke hitam
    });
  }

  void startCalibration() {
    print("Kalibrasi dimulai. Tetapkan posisi awIl ponsel.");

    accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
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
      ball.position.add(currentAcceleration * movementFactor);
      ball.position.clamp(
        Vector2(ball.size.x / 2, ball.size.y / 2),
        Vector2(size.x - ball.size.x / 2, size.y - ball.size.y / 2),
      );
    }
  }

  @override
  void onRemove() {
    accelerometerSubscription.cancel();
    lightSensor?.stopListening(); // Hentikan pendengaran sensor cahaya
    super.onRemove();
  }
}
