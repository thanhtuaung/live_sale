import 'package:atom_ui/on_clicked_listener.dart';
import 'package:atom_ui/src/ConstantStrings.dart';
import 'package:atom_ui/widgets/border_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWithRoundCorner extends StatefulWidget {
  final String labelText;
  late double width;
  late List<TextInputFormatter>? formatters = [];
  late bool needValidate = false;
  late TextInputType? inputType = TextInputType.text;
  final OnSavedTextField onSaved;
  final TextEditingController textEditingController = TextEditingController();

  TextFormFieldWithRoundCorner(this.labelText,
      {Key? key,
      required this.onSaved,
      this.width = double.infinity,
      this.formatters,
      this.inputType,
      this.needValidate = false})
      : super(key: key) {}

  @override
  TextFormFieldWithRoundCornerState createState() =>
      TextFormFieldWithRoundCornerState();
}

class TextFormFieldWithRoundCornerState
    extends State<TextFormFieldWithRoundCorner> {
  void clear() {
    widget.textEditingController.clear();
  }

  void setLabel(String label) {
    setState(() {
      widget.textEditingController.text = label;
      print(label);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextFormField(
        // controller: widget.textEditingController,
        keyboardType: widget.inputType,
        validator: (value) {
          if (widget.needValidate) {
            return value == null || value.isEmpty
                ? ConstantString.requiredTextFormField
                : null;
          }
          return null;
        },
        onSaved: (newValue) {
          widget.onSaved(newValue!);
        },
        inputFormatters: widget.formatters,
        decoration: InputDecoration(
          labelText: widget.labelText,
          counterText: "",
          border: outLineBorder,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

// class EditTextUtils {
//   TextFormField getCustomEditTextArea(
//       {String labelValue = "",
//         String hintValue = "",
//         bool? validation,
//         TextEditingController controller,
//         TextInputType keyboardType = TextInputType.text,
//         TextStyle textStyle,
//         String validationErrorMsg}) {
//     TextFormField textFormField = TextFormField(
//       keyboardType: keyboardType,
//       style: textStyle,
//       controller: controller,
//       validator: (String value) {
//         if (validation) {
//           if (value.isEmpty) {
//             return validationErrorMsg;
//           }
//         }
//       },
//       decoration: InputDecoration(
//           labelText: labelValue,
//           hintText: hintValue,
//           labelStyle: textStyle,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
//     );
//     return textFormField;
//   }
// }
