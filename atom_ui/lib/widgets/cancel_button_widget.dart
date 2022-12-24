import 'package:flutter/material.dart';

class CancelButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Size? btnSize;

  CancelButtonWidget({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ButtonStyle(
            // maximumSize: MaterialStateProperty.all(Size(75, 50)),
            minimumSize: MaterialStateProperty.all(Size(75, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.red)));
  }
}
