import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'wall_component.dart';

class BallComponent extends PositionComponent with CollisionCallbacks {
  final File? userPhoto;
  ui.Image? _image;
  late ShapeHitbox hitbox;
  bool alreadyInCollision = false;
  Vector2 lastVeloc = Vector2.all(0);

  BallComponent({this.userPhoto}) {
    size = Vector2.all(20.0);
    anchor = Anchor.center;
  }

  var velocity = Vector2(0, 0);

  void move() {
    position += velocity;
  }

  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    if (intersectionPoints.isNotEmpty && other is RectangleCollidable) {
      velocity = Vector2.zero();
      Vector2 intersection = position - intersectionPoints.first;
      Vector2 pushAway = intersection.normalized();
      position += pushAway;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (userPhoto != null) {
      _image = await _loadImageFromFile(userPhoto!);
    }
    final defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = false;
    add(hitbox);
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
      final circlePath = Path()..addOval(Rect.fromLTWH(0, 0, size.x, size.y));
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
