import 'package:light/light.dart';
import 'dart:async';

class LightSensor {
  late Light _light;
  StreamSubscription? _lightSubscription;
  double luxValue = 0.0;

  LightSensor() {
    _light = Light();
  }

  void startListening(Function(double) onData) {
    // Jika sudah ada subscription, batalkan dulu
    _lightSubscription?.cancel();

    // Mulai mendengarkan stream sensor cahaya
    _lightSubscription = _light.lightSensorStream.listen((luxValue) {
      this.luxValue = double.tryParse(luxValue.toString()) ?? 0.0;
      onData(this.luxValue);
    });
  }

  void stopListening() {
    // Hentikan pendengaran jika subscription ada
    _lightSubscription?.cancel();
    _lightSubscription = null;
  }

  double calculateOpacity() {
    // Ambil batas maksimum intensitas cahaya untuk opacity penuh (misalnya 200)
    double maxLux = 200.0;
    // Hasilkan nilai opacity yang halus, dari 0.0 hingga 1.0, berdasarkan nilai lux
    return (luxValue / maxLux).clamp(0.0, 1.0);
  }
}
