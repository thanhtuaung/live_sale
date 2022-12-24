import 'package:flutter/cupertino.dart';

class TicketHdrShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 24;

    path.moveTo(0, radius);

    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(radius / 2, size.height);

    path.quadraticBezierTo(
        radius / 2, size.height - radius / 2, 0, size.height - radius / 2);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class InvoiceContentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double radius = 24;
    double paperCropRadius = 5;

    path.moveTo(radius / 2, 0);

    path.quadraticBezierTo(radius / 2, radius / 2, 0, radius / 2);
    path.lineTo(0, size.height);

    double maxWidth = size.width.abs();
    double sideOffset = (maxWidth % (paperCropRadius * 3)) / 2;
    int numOfArc = (maxWidth / (paperCropRadius * 3)).truncate();

    path.relativeLineTo(sideOffset, 0);
    for (int i = 0; numOfArc > i; i++) {
      path.relativeLineTo(paperCropRadius * 0.5, 0);
      path.relativeArcToPoint(
        Offset(paperCropRadius * 2, 0),
        radius: Radius.circular(paperCropRadius),
      );
      path.relativeLineTo(paperCropRadius * 0.5, 0);
    }
    path.relativeLineTo(sideOffset, 0);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
