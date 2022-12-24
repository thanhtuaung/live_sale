import 'package:atom_ui/src/ConstantStrings.dart';
import 'package:flutter/material.dart';

class EditButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool showIcon;

  EditButtonWidget({required this.onPressed, this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Row(children: [
          showIcon ? Icon(Icons.edit) : Container(),
          showIcon ? SizedBox() : SizedBox(width: 1),
          Text(ConstantString.edit),
        ]),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green)));
  }
}
