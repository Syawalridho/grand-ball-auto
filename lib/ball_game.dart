import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'ball_component.dart';

class BallGame extends FlameGame {
  late BallComponent ball; // Komponen bola
  late StreamSubscription<AccelerometerEvent> accelerometerSubscription;

  // Faktor pengali untuk mengontrol sensitivitas pergerakan
  final double movementFactor = 3.0;

  // Variabel untuk menyimpan akselerasi yang dihaluskan
  Vector2 currentAcceleration = Vector2.zero();

  // Posisi awal untuk kalibrasi
  Vector2 initialOffset = Vector2.zero();

  // Flag untuk mengecek apakah sudah dikalibrasi
  bool isCalibrated = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Tambahkan komponen bola ke game di posisi tengah layar
    ball = BallComponent()
      ..position = Vector2(size.x / 2, size.y / 2); // Posisi awal bola di tengah layar
    add(ball);
  }

  // Fungsi untuk memulai kalibrasi dari UI
  void startCalibration() {
    print("Kalibrasi dimulai. Tetapkan posisi awal ponsel.");

    // Mulai mengambil data akselerometer untuk kalibrasi
    accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!isCalibrated) {
        // Set nilai akselerometer sebagai titik tengah
        initialOffset = Vector2(event.x, event.y);
        isCalibrated = true; // Tandai kalibrasi selesai
        print("Kalibrasi selesai. Titik tengah ditetapkan.");
      }

      // Mengatur nilai akselerometer yang dikalibrasi
      currentAcceleration = Vector2(
        -(event.x - initialOffset.x),
        event.y - initialOffset.y,
      );
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Menggunakan data akselerometer untuk menggerakkan bola dengan sensitivitas tinggi
    ball.position.add(currentAcceleration * movementFactor);

    // Menjaga bola agar tidak keluar dari batas layar di semua sisi
    ball.position.clamp(
        Vector2(ball.size.x / 2, ball.size.y / 2), // Batas atas dan kiri
        Vector2(size.x - ball.size.x / 2, size.y - ball.size.y / 2) // Batas kanan dan bawah
    );
  }


  @override
  void onRemove() {
    accelerometerSubscription.cancel(); // Hentikan langganan saat game berhenti
    super.onRemove();
  }
}
