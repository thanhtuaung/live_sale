import 'package:flutter/material.dart';

/// I'm using [RoundedRectangleBorder] as my reference...
class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();
    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect react = _borderRadius.resolve(textDirection).toRRect(rect);
    // rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    // double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    // return Path()
    //   ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
    //   ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
    //   ..relativeLineTo(-x / 2 * r, y * r)
    //   ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
    //   ..relativeLineTo(-x / 2 * r, -y * r);
    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(react.width - 30, 0);
    path.lineTo(react.width - 20, -10);
    path.lineTo(react.width - 10, 0);
    path.quadraticBezierTo(react.width, 0, react.width, 10);
    path.lineTo(react.width, react.height - 10);
    path.quadraticBezierTo(
        react.width, react.height, react.width - 10, react.height);
    path.lineTo(10, react.height);
    path.quadraticBezierTo(0, react.height, 0, react.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
