import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'dart:async';

class LightSensor {
  late Light _light;
  late StreamSubscription _lightSubscription;
  double luxValue = 0.0;

  LightSensor() {
    _light = Light();
  }

  void startListening(Function(double) onData) {
    _lightSubscription = _light.lightSensorStream.listen((luxValue) {
      this.luxValue = double.tryParse(luxValue.toString()) ?? 0.0;
      onData(this.luxValue);
    });
  }

  void stopListening() {
    _lightSubscription.cancel();
  }

  double calculateOpacity() {
    return (luxValue <= 87) ? (luxValue / 87).clamp(0.0, 1.0) : 1.0;
  }
}
