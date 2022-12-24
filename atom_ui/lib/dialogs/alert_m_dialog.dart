import 'dart:convert';

import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:atom_ui/widgets/memory_asset_image_view.dart';
import 'package:atom_ui/widgets/ok_button_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlertMDialog extends StatefulWidget {
  final String descriptions;
  final String title;
  final String avatarImage;
  VoidCallback callback = () {};
  final String btnText;
  Size? btnSize;

  AlertMDialog(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.avatarImage,
      required this.callback,
      required this.btnText,
      this.btnSize})
      : super(key: key);

  @override
  _AlertMDialogState createState() => _AlertMDialogState();
}

class _AlertMDialogState extends State<AlertMDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
              child: Container(
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(base64Decode(widget.avatarImage)),
                      onError: (e, error) =>
                          AssetImage('assets/images/logo_black_white.png')),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                width: 100,
                height: 100,
                // child: MemoryAssetImage(memoryImage: widget.avatarImage),
              ),
              top: -ConstantDimens.avatar_radius),
          Container(
            padding: EdgeInsets.all(ConstantDimens.padding),
            margin:
                EdgeInsets.only(top: ConstantDimens.margin_from_avatar_image),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                SizedBox(height: ConstantDimens.padding),
                Text(widget.descriptions, style: TextStyle(fontSize: 15)),
                SizedBox(height: ConstantDimens.padding),
                OkButtonWidget(
                    text: widget.btnText,
                    onPressed: widget.callback,
                    size: widget.btnSize ?? Size(100, 50)),
                SizedBox(height: ConstantDimens.padding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
