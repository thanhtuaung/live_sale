import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    print(size.width.toString());
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(size.width / 7, 0), radius: 8.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 7, size.height), radius: 8.0));
    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 15.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 15.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
