import 'package:atom_ui/on_clicked_listener.dart';
import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:atom_ui/widgets/number_keypad_widget.dart';
import 'package:flutter/material.dart';

class NumberInputWidget extends StatelessWidget {
  final OnClickCallBack<String> onClick;
  late String inputString = '';
  final int maxLengthOfInput = 15;
  late TextEditingController _textEditingController = TextEditingController();

  NumberInputWidget({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6?.fontSize),
            maxLength: 10,
            textAlign: TextAlign.end,
            controller: _textEditingController,
            readOnly: true,
            showCursor: false,
            decoration: InputDecoration(
              counterText: "",
              border: createBorder(Colors.green),
              focusedBorder: createBorder(Colors.green),
              enabledBorder: createBorder(Colors.green),
              errorBorder: createBorder(Colors.red),
            ),
          ),
          SizedBox(height: ConstantDimens.smallPadding),
          NumberKeypadWidget(onClick: (data) {
            inputString = _changeProcess(data, inputString);
            _textEditingController.text = inputString;
            onClick.call(inputString);
          })
        ],
      ),
    );
  }

  createBorder(Color color) {
    return OutlineInputBorder(
        borderSide:
            BorderSide(color: color, width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.horizontal(
            right: Radius.circular(8.0), left: Radius.circular(8.0)));
  }

  String _changeProcess(String data, String intentChangeString) {
    if (data == 'backspace') {
      if (intentChangeString.length > 0)
        return intentChangeString.substring(0, intentChangeString.length - 1);
      return '';
    } else if (data == '.') {
      if (inputString.length <= 0) {
        return '0.$intentChangeString';
      }
      if (intentChangeString.contains('.')) {
        return intentChangeString;
      } else {
        if (intentChangeString.length < maxLengthOfInput) {
          return '$intentChangeString.';
        } else {
          return intentChangeString;
        }
      }
    } else {
      if (intentChangeString.length < maxLengthOfInput) {
        return '$intentChangeString$data';
      }
      return intentChangeString;
    }
  }
}
