import 'package:flutter/material.dart';

class QtyInputBtnWidget extends StatelessWidget {
  late bool? isHorizontal;
  late VoidCallback onPlusClicked;
  late VoidCallback onNumberPadClicked;
  late VoidCallback onMinusClicked;

  QtyInputBtnWidget(
      {Key? key,
      this.isHorizontal = true,
      required this.onPlusClicked,
      required this.onNumberPadClicked,
      required this.onMinusClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHorizontal!
        ? _container(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _btnCreate(Icons.remove_circle, onMinusClicked),
              _btnCreate(Icons.apps_rounded, onNumberPadClicked),
              _btnCreate(Icons.add_circle, onPlusClicked),
            ],
          ))
        : _container(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _btnCreate(Icons.remove_circle, onMinusClicked),
                _btnCreate(Icons.apps_rounded, onNumberPadClicked),
                _btnCreate(Icons.add_circle, onPlusClicked),
              ],
            ),
          );
  }

  _container(Widget child) {
    return Material(
      color: Colors.transparent,
      child: Container(
        // width: isHorizontal! ? 130 : 56,
        // height: isHorizontal! ? 56 : 130,
        child: child,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  _btnCreate(IconData iconData, VoidCallback onclick) {
    return InkWell(
      child: Icon(iconData, color: Colors.white, size: 30),
      onTap: onclick,
    );
  }
}

// Material(
// child: Container(
// width: 130,
// height: 56,
// child: Row(children: [
// _btnCreate(Icons.add_circle, onPlusClicked),
// _btnCreate(Icons.apps_rounded, onPlusClicked),
// _btnCreate(Icons.remove_circle, onMinusClicked),
// ]),
// decoration: BoxDecoration(
// color: Colors.red,
// border: Border.all(color: Colors.red),
// borderRadius: BorderRadius.circular(16),
// ),
// ),
// );
