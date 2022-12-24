import 'dart:ui';

import 'package:flutter/material.dart';

class RoundCornerButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  late double width;
  late double height;
  late Color color;

  RoundCornerButton(this.text, this.callback,
      {Key? key, this.width = 50, this.height = 20, this.color = Colors.green})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (width == 0 && height == 0) {
      child = SizedBox.fromSize(
        child: Center(child: Text(text)),
      );
    } else {
      child = SizedBox(
        width: width,
        height: height,
        child: Center(child: Text(text)),
      );
    }
    return ElevatedButton(
      onPressed: callback,
      child: child,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.transparent)))),
    );
  }
}
