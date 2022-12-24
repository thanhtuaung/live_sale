import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithRoundCorner extends StatefulWidget {
  late TextEditingController? textEditingController;
  final String? labelText;
  late double width;
  late TextInputType? inputType;
  late String? errorMessage;
  late List<TextInputFormatter>? inputFormatter;
  late ValueChanged<String>? onValueChange;
  late FocusNode? focusNode;

  TextFieldWithRoundCorner(
      {Key? key,
      this.labelText,
      this.textEditingController,
      this.onValueChange,
      this.width = 250,
      this.errorMessage,
      this.focusNode,
      this.inputType,
      this.inputFormatter})
      : super(key: key);

  @override
  TextFieldWithRoundCornerState createState() =>
      TextFieldWithRoundCornerState();
}

class TextFieldWithRoundCornerState extends State<TextFieldWithRoundCorner> {
  TextFieldWithRoundCornerState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextField(
          focusNode: widget.focusNode,
          keyboardType: widget.inputType,
          inputFormatters: widget.inputFormatter,
          controller: widget.textEditingController,
          onChanged: widget.onValueChange,
          decoration: InputDecoration(
            // prefixIcon: bll ? Icon(Icons.clear) : null,
            labelText: widget.labelText,
            errorText: widget.errorMessage,
            counterText: "",
            border: createBorder(Colors.green),
            focusedBorder: createBorder(Colors.blue),
            // enabledBorder: createBorder(Colors.black),
            // errorBorder: createBorder(Colors.red),
          )),
    );
  }

  void clear() {
    widget.textEditingController?.clear();
  }

  createBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2, style: BorderStyle.solid),
      borderRadius: BorderRadius.horizontal(
          right: Radius.circular(8.0), left: Radius.circular(8.0)),
    );
  }
}
