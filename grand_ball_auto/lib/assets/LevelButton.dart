import 'package:flutter/material.dart';

class LevelButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final IconData? icon;
  final double width;

  const LevelButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: Size(width, 82),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: icon != null
          ? Icon(
              icon,
              color: const Color(0xFFD9D9D9),
              size: 40,
            )
          : Text(
              text,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
    );
  }
}
