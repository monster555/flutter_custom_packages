import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Color color;

  const ArrowPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = color;

    Path path = Path()
      ..moveTo(size.width * 1.0, size.height * 0.0)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.02,
          size.width * 0.80, size.height * 0.125)
      ..cubicTo(size.width * 0.75, size.height * 0.15, size.width * 0.55,
          size.height * 1.0, size.width * 0.50, size.height * 1.0)
      ..cubicTo(size.width * 0.45, size.height * 1.0, size.width * 0.25,
          size.height * 0.15, size.width * 0.20, size.height * 0.125)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.02,
          size.width * 0.0, size.height * 0.0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
