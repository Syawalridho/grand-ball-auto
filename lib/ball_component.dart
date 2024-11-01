import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class BallComponent extends PositionComponent {
  BallComponent() {
    size = Vector2.all(50.0); // Ukuran bola 50x50
    anchor = Anchor.center; // Titik pusat komponen ada di tengah
  }

  @override
  void render(Canvas canvas) {
    final paint = BasicPalette.blue.paint(); // Warna bola
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}
