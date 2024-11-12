import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Light Sensor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LightSensorPage(),
    );
  }
}

class LightSensorPage extends StatefulWidget {
  @override
  _LightSensorPageState createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  double _luxValue = 0.0; // Variabel untuk menyimpan intensitas cahaya
  late Light _light;
  late StreamSubscription _lightSubscription;

  @override
  void initState() {
    super.initState();
    _light = Light();
    _startListening();
  }

  void _startListening() {
    _lightSubscription = _light.lightSensorStream.listen((luxValue) {
      setState(() {
        _luxValue = double.tryParse(luxValue.toString()) ??
            0.0; // Mengonversi nilai lux ke double
      });
    });
  }

  double _calculateOpacity(double luxValue) {
    // Jika lux di bawah atau sama dengan 87, atur opacity proporsional (0 hingga 1)
    // Jika di atas 87, opacity maksimal (1)
    return (luxValue <= 87) ? (luxValue / 87).clamp(0.0, 1.0) : 1.0;
  }

  @override
  void dispose() {
    _lightSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background hitam
          Container(
            color: Colors.black,
          ),
          // Overlay putih dengan opacity yang menyesuaikan intensitas cahaya
          Opacity(
            opacity: _calculateOpacity(_luxValue),
            child: Container(
              color: Colors.white,
            ),
          ),
          // Menampilkan informasi intensitas cahaya
          Center(
            child: Text(
              'Intensity of Light (Lux): ${_luxValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
