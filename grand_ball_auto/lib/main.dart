import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:screen_brightness/screen_brightness.dart';

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
  Light? _light;
  double _targetBrightness = 0.5;
  String _luxValue = '0';
  final ScreenBrightness _screenBrightness = ScreenBrightness(); // Buat instans

  @override
  void initState() {
    super.initState();
    _light = Light();
    _startListening();
  }

  void _startListening() {
    _light?.lightSensorStream.listen((luxValue) {
      setState(() {
        _luxValue = luxValue.toString();
        _updateTargetBrightness(double.parse(luxValue.toString()));
      });
    });
  }

  void _updateTargetBrightness(double luxValue) {
    if (luxValue >= 80) {
      _targetBrightness = 0.3;
    } else if (luxValue >= 40) {
      _targetBrightness = 0.5;
    } else {
      _targetBrightness = 0.8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Light Sensor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Intensity of Light (Lux): $_luxValue',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.5, end: _targetBrightness),
              duration: Duration(seconds: 1),
              builder: (context, double brightness, _) {
                _screenBrightness.setScreenBrightness(brightness); // Panggil melalui instans
                return Text(
                  'Screen Brightness: ${(brightness * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 20),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _light = null;
    super.dispose();
  }
}
