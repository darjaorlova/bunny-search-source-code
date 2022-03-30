import 'package:flutter/material.dart';

class BackgroundWaveClipper extends CustomClipper<Path> {
  BackgroundWaveClipper();

  @override
  Path getClip(Size size) {
    var path = Path();
    final p1Diff = ((140 - size.height) * 0.28).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);
    final p2Diff = ((140 - size.height) * 1).truncate().abs();
    final endPoint = Offset(size.width, size.height - p2Diff);
    final p3Diff = ((140 - size.height) * 0.72).truncate().abs();
    final firstControlPoint = Offset(-100, size.height - p3Diff);
    final p4Diff = ((140 - size.height) * 0.575).abs();
    final secondControlPoint = Offset(size.width / 2.5, size.height + p4Diff);
    path.cubicTo(firstControlPoint.dx, firstControlPoint.dy,
        secondControlPoint.dx, secondControlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => oldClipper != this;
}