// ekrandaki kutu/etiket (mock)

import 'package:flutter/material.dart';

class DetectionOverlay extends StatelessWidget {
  const DetectionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Şimdilik sabit bir kutu çizelim(mock)
    return IgnorePointer(
      child: CustomPaint(
        painter: _BoxPainter(),
        child: Container(),
      ),
    );
  }
}

class _BoxPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.lightGreenAccent;

    final rect = Rect.fromLTWH(size.width * 25, size.height * 25, size.width * .5, size.height * 35);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}