import 'package:flutter/material.dart';

class RemovablePaint extends CustomPainter {
  RemovablePaint({
    required this.animation,
    this.color,
  })  : actionPaint = Paint()
          ..color = color ?? Colors.white
          ..style = PaintingStyle.fill,
        super(repaint: animation);

  final Animation animation;

  final Color? color;

  final Paint actionPaint;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0.0, 0.0);
    path.quadraticBezierTo(
      size.width,
      0,
      size.width,
      0,
    );
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height,
    );
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height,
    );
    path.quadraticBezierTo(
      0,
      0,
      0,
      0,
    );
    canvas.drawPath(path, actionPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      (oldDelegate as RemovablePaint).animation != animation;
}
