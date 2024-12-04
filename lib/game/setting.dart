import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final double friction;
  final double mass;
  final double movementFactor;
  final Function(double, double, double) onSettingsChanged;

  const SettingsScreen({
    required this.friction,
    required this.mass,
    required this.movementFactor,
    required this.onSettingsChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double currentFriction;
  late double currentMass;
  late double currentMovementFactor;

  @override
  void initState() {
    super.initState();
    currentFriction = widget.friction;
    currentMass = widget.mass;
    currentMovementFactor = widget.movementFactor;
  }

  void _updateSettings() {
    widget.onSettingsChanged(
        currentFriction, currentMass, currentMovementFactor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Friction Slider
            Text("Friction (Gesekan): Semakin kecil, bola bergerak lebih lama"),
            Slider(
              value: currentFriction,
              min: 0.9,
              max: 1.0,
              divisions: 10,
              label: currentFriction.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  currentFriction = value;
                });
                _updateSettings();
              },
            ),
            Text("Nilai Friction: ${currentFriction.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            // Mass Slider
            Text("Mass (Massa bola): Semakin besar, bola lebih berat"),
            Slider(
              value: currentMass,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              label: currentMass.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  currentMass = value;
                });
                _updateSettings();
              },
            ),
            Text("Nilai Mass: ${currentMass.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            // Movement Factor Slider
            Text("Movement Factor: Semakin besar, bola lebih responsif"),
            Slider(
              value: currentMovementFactor,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              label: currentMovementFactor.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  currentMovementFactor = value;
                });
                _updateSettings();
              },
            ),
            Text(
                "Nilai Movement Factor: ${currentMovementFactor.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
