import 'package:atom_ui/on_clicked_listener.dart';
import 'package:flutter/material.dart';

class NumberKeypadWidget extends StatelessWidget {
  final OnClickCallBack<String> onClick;
  late String inputString = '';

  NumberKeypadWidget({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      textDirection: TextDirection.ltr,
      defaultColumnWidth: FlexColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          createNumberKey('1'),
          createNumberKey('2'),
          createNumberKey('3'),
        ]),
        TableRow(children: [
          createNumberKey('4'),
          createNumberKey('5'),
          createNumberKey('6'),
        ]),
        TableRow(children: [
          createNumberKey('7'),
          createNumberKey('8'),
          createNumberKey('9'),
        ]),
        TableRow(children: [
          createNumberKey('.'),
          createNumberKey('0'),
          _createBackSpace(Icons.backspace_outlined)
        ]),
      ],
    );
  }

  Widget createNumberKey(String number) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextButton(
          onPressed: () {
            this.onClick.call(number);
          },
          child: Text(
            number,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          style: TextButton.styleFrom(
            primary: Colors.black,
            minimumSize: Size(65, 65),
            backgroundColor: Colors.lightGreen,
            shape: CircleBorder(),
          )),
    );
  }

  Widget _createBackSpace(IconData iconData) {
    return CircleAvatar(
      backgroundColor: Colors.red,
      minRadius: 30,
      child: IconButton(
          onPressed: () {
            this.onClick.call('backspace');
          },
          icon: Icon(iconData, color: Colors.white)),
    );
  }
}
