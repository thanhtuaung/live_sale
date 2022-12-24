import 'package:flutter/material.dart';

class ColumnRowSpacing extends StatelessWidget {
  late double paddingWidth;
  late double paddingHeight;

  ColumnRowSpacing(
      {Key? key, this.paddingHeight = 8.0, this.paddingWidth = 8.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: paddingWidth,
      height: paddingHeight,
    );
  }
}
