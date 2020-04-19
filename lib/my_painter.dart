import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final double anim;
  final double anim2;
  final Color color;

  MyPainter(this.anim, this.anim2, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(320 * anim + (size.width - 320) * anim2, 0)
      ..cubicTo(
          396 * anim + (size.width - 396) * anim2,
          117,
          313 * anim + (size.width - 313) * anim2,
          105.5,
          295 * anim + (size.width - 295) * anim2,
          199)
      ..cubicTo(
          277 * anim + (size.width - 277) * anim2,
          319.5,
          405 * anim + (size.width - 405) * anim2,
          446,
          295 * anim + (size.width - 295) * anim2,
          529)
      ..cubicTo(
          162 * anim + (size.width - 162) * anim2,
          673,
          339 * anim + (size.width - 339) * anim2,
          702.6,
          247 * anim + (size.width - 247) * anim2,
          845)
      ..cubicTo(
          205 * anim + (size.width - 205) * anim2,
          892,
          252 * anim + (size.width - 252) * anim2,
          955,
          285 * anim + (size.width - 285) * anim2,
          960)
      ..lineTo(0, 960)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyPainter oldDelegate) => false;
}
