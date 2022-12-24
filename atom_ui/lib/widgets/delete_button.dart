import 'package:atom_ui/src/ConstantStrings.dart';
import 'package:flutter/material.dart';

class DeleteButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool showIcon;
  late Size? size;

  DeleteButtonWidget(
      {required this.onPressed, this.showIcon = true, this.size}) {
    if (this.size == null) {
      this.size = Size(75, 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          showIcon ? Icon(Icons.delete) : Container(),
          showIcon ? SizedBox() : SizedBox(width: 1),
          Text(ConstantString.delete)
        ]),
        style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(this.size),
            minimumSize: MaterialStateProperty.all(this.size),
            backgroundColor: MaterialStateProperty.all(Colors.red)));
  }
}
