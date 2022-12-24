import 'package:flutter/material.dart';

enum ProgressBtnStates { Init, Loading, Success, Fail }

class ProgressBtn extends StatefulWidget {
  final String initText;
  final VoidCallback onClicked;
  double? minWidth;
  double? minHeight;

  ProgressBtn(
      {Key? key,
      required this.initText,
      required this.onClicked,
      this.minWidth = 200,
      this.minHeight = 56})
      : super(key: key);

  @override
  State<ProgressBtn> createState() => ProgressBtnState();
}

class ProgressBtnState extends State<ProgressBtn> {
  late Widget _internalWidget;
  late bool _clickable = true;
  late Color _btnColor = Colors.green;

  @override
  void initState() {
    _btnColor = Colors.green;
    _clickable = true;
    _internalWidget = _internalText(widget.initText);
    super.initState();
  }

  void setProgressState(ProgressBtnStates states, String text) {
    if (states == ProgressBtnStates.Init) {
      _btnColor = Colors.green;
      _clickable = true;
      _internalWidget = _internalText(widget.initText);
    } else if (states == ProgressBtnStates.Loading) {
      _clickable = false;
      _btnColor = Colors.green;
      _internalWidget = Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CircularProgressIndicator());
    } else if (states == ProgressBtnStates.Success) {
      _btnColor = Colors.green;
      _clickable = false;
      _internalWidget = _internalText(text);
    } else if (states == ProgressBtnStates.Fail) {
      _btnColor = Colors.red;
      _clickable = false;
      _internalWidget = _internalText(text);
    }
  }

  void resetToInit() {
    setState(() {
      _clickable = true;
      _btnColor = Colors.green;
      _internalWidget = _internalText(widget.initText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (_clickable) {
            widget.onClicked.call();
          }
        },
        child: _internalWidget,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(_btnColor),
            minimumSize: MaterialStateProperty.all(
                Size(widget.minWidth!, widget.minHeight!))));
  }

  Text _internalText(String text) {
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 25.0));
  }
}
