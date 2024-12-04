import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;

class BallComponent extends PositionComponent {
  final File? userPhoto;
  ui.Image? _image;

  BallComponent({this.userPhoto}) {
    size = Vector2.all(50.0);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (userPhoto != null) {
      _image = await _loadImageFromFile(userPhoto!);
    }
  }

  Future<ui.Image> _loadImageFromFile(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void render(Canvas canvas) {
    if (_image != null) {
      // Membuat kliping lingkaran untuk membuat gambar menjadi bulat
      canvas.save();
      final circlePath = Path()
        ..addOval(Rect.fromLTWH(0, 0, size.x, size.y));
      canvas.clipPath(circlePath);
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.x, size.y),
        image: _image!,
        fit: BoxFit.cover,
      );
      canvas.restore();
    } else {
      // Jika tidak ada foto, tampilkan bola dengan warna hijau
      final paint = BasicPalette.green.paint();
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    }
  }
}
