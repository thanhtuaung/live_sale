import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class TextFormFieldWithLabel extends StatefulWidget {
  late TextEditingController? textEditingController;
  final String? labelText;
  late double width;
  final String? hintText;
  final TextInputType? inputType;
  final String? errorMessage;
  final List<TextInputFormatter>? inputFormatter;
  final ValueChanged<String>? onValueChange;
  final FormFieldSetter<String>? onValueSave;
  final FocusNode? focusNode;
  final String? initValue;
  final bool? isPassword;
  final bool? isEnable;
  final bool? readOnly;
  final FormFieldValidator<String>? formFieldValidator;

  TextFormFieldWithLabel({
    Key? key,
    this.initValue,
    this.labelText,
    this.readOnly,
    this.errorMessage,
    this.isEnable,
    this.textEditingController,
    this.onValueChange,
    this.width = 250,
    this.formFieldValidator,
    this.onValueSave,
    this.focusNode,
    this.isPassword,
    this.hintText,
    this.inputType,
    this.inputFormatter,
  }) : super(key: key);

  @override
  TextFormFieldWithLabelState createState() => TextFormFieldWithLabelState();
}

class TextFormFieldWithLabelState extends State<TextFormFieldWithLabel> {
  TextFormFieldWithLabelState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextFormField(
          readOnly: widget.readOnly ?? false,
          enabled: widget.isEnable,
          obscureText: widget.isPassword ?? false,
          initialValue: widget.initValue,
          onSaved: widget.onValueSave,
          focusNode: widget.focusNode,
          keyboardType: widget.inputType,
          inputFormatters: widget.inputFormatter,
          controller: widget.textEditingController,
          onChanged: widget.onValueChange,
          validator: widget.formFieldValidator,
          decoration: InputDecoration(
            // prefixIcon: bll ? Icon(Icons.clear) : null,
            labelText: widget.labelText,
            errorText: widget.errorMessage,
            counterText: "",
            hintText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          )),
    );
  }

  void clear() {
    widget.textEditingController?.clear();
  }
}

// kyaw gyi don't write shit code V1
// class A {
//   A(int x);
// }
//
// class B extends A {
//   int i;
//
//   B(int i)
//       : i = _getI(),
//         super(i);
//
//   static _getI() {
//     return 100;
//   }
// }
