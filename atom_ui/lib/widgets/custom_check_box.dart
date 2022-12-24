import 'package:atom_ui/on_clicked_listener.dart';
import 'package:flutter/material.dart';

class CustomClickBox extends StatefulWidget {
  OnClickCallBack<bool> onCheckChangeListener;
  bool? value;

  CustomClickBox(
      {Key? key, required this.onCheckChangeListener, required this.value})
      : super(key: key) {
    value = value ?? false;
  }

  @override
  State<CustomClickBox> createState() => _CustomClickBoxState();
}

class _CustomClickBoxState extends State<CustomClickBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          child: widget.value!
              ? Icon(Icons.check_box_rounded,
                  color: Theme.of(context).colorScheme.secondaryContainer)
              : Icon(Icons.check_box_outline_blank_rounded),
          onTap: () {
            setState(() {
              widget.value = !widget.value!;
            });
            widget.onCheckChangeListener.call(widget.value!);
          }),
    );
  }
}
