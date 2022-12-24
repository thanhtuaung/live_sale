import 'package:flutter/material.dart';

class OkButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Size? size;

  OkButtonWidget({required this.onPressed, required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    if (this.size == null) {
      this.size = Size(75, 50);
    }
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(this.size),
            minimumSize: MaterialStateProperty.all(this.size),
            backgroundColor: MaterialStateProperty.all(Colors.green)));
  }
}
