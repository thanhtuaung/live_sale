import 'package:flutter/material.dart';

class FlatMaterialCreateButton extends StatelessWidget {
  late double? height;
  late Color? color;
  late String text;
  late Color? textColor;
  late double? minWidth;
  late VoidCallback onPressed;

  FlatMaterialCreateButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.minWidth,
      this.color = Colors.green,
      this.textColor = Colors.white,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: this.minWidth,
      height: height,
      color: this.color,
      child: Text(text, style: TextStyle(color: this.textColor)),
      onPressed: this.onPressed,
    );
  }
}
