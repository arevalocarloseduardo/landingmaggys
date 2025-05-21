import 'package:flutter/material.dart';
import 'dart:math';

class TopSemicircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addArc(Rect.fromLTWH(0, 0, size.width, size.height * 2), pi, pi);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4, size.height,
      size.width / 2, size.height - 20,
    );
    path.quadraticBezierTo(
      3 * size.width / 4, size.height - 40,
      size.width, size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
} 