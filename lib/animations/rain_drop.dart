import 'package:flutter/material.dart';

class RainDrop extends CustomPainter {
  final double progress;

  RainDrop(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2;

    for (var i = 0; i < 20; i++) {
      final x = (i * 20) % size.width;
      final y = ((progress + i) * 20) % size.height;
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RainDrop oldDelegate) => true;
}
