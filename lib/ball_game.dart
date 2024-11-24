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
  late RectangleComponent background;

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

  BallGame({this.userPhoto, this.startWithCalibration = false, this.lightSensor});

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
      // Perbarui kecepatan berdasarkan percepatan dan massa bola
      Vector2 accelerationWithMass = currentAcceleration / ballMass;
      velocity += accelerationWithMass * movementFactor * dt;

      // Terapkan gesekan
      velocity *= friction;

      // Perbarui posisi bola
      ball.position += velocity;

      // Pantulkan jika bola menyentuh tepi layar
      if (ball.position.x <= ball.size.x / 2 || ball.position.x >= size.x - ball.size.x / 2) {
        velocity.x = -velocity.x * 0.8; // Pantulan dengan pengurangan energi
        ball.position.x = ball.position.x.clamp(ball.size.x / 2, size.x - ball.size.x / 2);
      }
      if (ball.position.y <= ball.size.y / 2 || ball.position.y >= size.y - ball.size.y / 2) {
        velocity.y = -velocity.y * 0.8; // Pantulan dengan pengurangan energi
        ball.position.y = ball.position.y.clamp(ball.size.y / 2, size.y - ball.size.y / 2);
      }
    }
  }

  @override
  void onRemove() {
    accelerometerSubscription.cancel();
    lightSensor?.stopListening();
    super.onRemove();
  }
}
