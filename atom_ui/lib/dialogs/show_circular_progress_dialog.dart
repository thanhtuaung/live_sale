import 'package:flutter/material.dart';

class ShowCircularProgressDialog {
  bool _showingProgress = false;

  ShowCircularProgressDialog(BuildContext context) {
    _showingProgress = true;
    showCircularProgressDialog(context);
  }

  bool isShowingDialog() => _showingProgress;
}

showCircularProgressDialog(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.transparent,
            child: Card(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(25),
                  child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
    },
  );
}
