import 'package:flutter/material.dart';

import '../on_clicked_listener.dart';

class CardViewWidget extends StatelessWidget {
  final OnClickCallBack<bool> callBack;
  bool returnBool = true;

  CardViewWidget(this.callBack);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          callBack.call(returnBool = !returnBool);
        },
        child: Text('Delete'));
  }
}
