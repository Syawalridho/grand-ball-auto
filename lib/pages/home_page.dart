import 'package:flutter/material.dart';
import 'level_selection_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../game/ball_game.dart';
import 'package:flame/game.dart';
import '../game/light_sensor.dart';
import '../game/setting.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File? _userPhoto;
  LightSensor? _lightSensor;
  double _luxValue = 0.0;
  bool isLightSensorActive = false;

  // Game settings
  double _friction = 0.98;
  double _mass = 2.0;
  double _movementFactor = 3.0;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _userPhoto = File(pickedFile.path);
      });
    }
  }

  void _toggleLightSensor() {
    setState(() {
      if (isLightSensorActive) {
        _lightSensor?.stopListening();
        isLightSensorActive = false;
      } else {
        _lightSensor = LightSensor();
        _lightSensor?.startListening((luxValue) {
          setState(() {
            _luxValue = luxValue;
          });
        });
        isLightSensorActive = true;
      }
    });
  }

  double _calculateBackgroundOpacity() {
    if (!isLightSensorActive)
      return 1.0; // Default full brightness if sensor is off
    return _luxValue > 50
        ? 1.0
        : 0.0; // Set opacity based on light intensity threshold
  }

  void _startGame(BuildContext context) {
    if (_userPhoto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameWidget(
            game: BallGame(
              userPhoto: _userPhoto,
              startWithCalibration: true,
              lightSensor: _lightSensor,
            )
              ..friction = _friction
              ..ballMass = _mass
              ..movementFactor = _movementFactor,
          ),
        ),
      );
    }
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          friction: _friction,
          mass: _mass,
          movementFactor: _movementFactor,
          onSettingsChanged: (newFriction, newMass, newMovementFactor) {
            setState(() {
              _friction = newFriction;
              _mass = newMass;
              _movementFactor = newMovementFactor;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(129, 226, 243, 1), // Top color
                      Color.fromRGBO(40, 146, 165, 1), // Bottom color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        label: 'PLAY',
                        onPressed: () {
                          print("PLAY");
                          _startGame(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'SKIN',
                        onPressed: () {
                          print('Button SKIN pressed ...');
                          _takePhoto();
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'SETTINGS',
                        onPressed: () {
                          print('Button SETTINGS pressed ...');
                          _openSettings(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const HeaderImage(),
              const FooterImage(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({required this.label, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 43,
          fontWeight: FontWeight.w900,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class HeaderImage extends StatelessWidget {
  const HeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 60,
            left: 60,
            right: 60), // Tambahkan padding 30px pada kiri dan kanan
        child: Image.asset(
          'lib/assets/images/GBA.png',
          width: MediaQuery.of(context).size.width -
              200, // Kurangi 60px agar sesuai dengan padding kiri dan kanan
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class FooterImage extends StatelessWidget {
  const FooterImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'lib/assets/images/Sand.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
