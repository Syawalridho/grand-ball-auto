import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Finish extends PositionComponent with CollisionCallbacks {
  final _defaultColor = Colors.green;

  late ShapeHitbox hitbox;

  Finish(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(30),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;

    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;

    add(hitbox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    print("FINISH");
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }

  void render(Canvas canvas) {
    super.render(canvas); // Call the superclass's render to render the position

    final paint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill; // Set the fill style to paint the box

    canvas.drawRect(size.toRect(), paint);
  }
}

class Start extends PositionComponent {
  final _defaultColor = Colors.black;

  Start(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(30),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {}

  @override
  void render(Canvas canvas) {
    super.render(canvas); // Call the superclass's render to render the position

    final paint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill; // Set the fill style to paint the box

    canvas.drawRect(size.toRect(), paint);
  }
}

class RectangleCollidable extends PositionComponent with CollisionCallbacks {
  final _defaultColor = Colors.cyan;

  late ShapeHitbox hitbox;

  RectangleCollidable(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(30),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;

    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;

    add(hitbox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }

  void render(Canvas canvas) {
    super.render(canvas); // Call the superclass's render to render the position

    final paint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.fill; // Set the fill style to paint the box

    // Draw the rectangle
    canvas.drawRect(size.toRect(), paint);
  }
}
