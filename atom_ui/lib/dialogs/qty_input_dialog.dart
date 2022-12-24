import 'package:atom_ui/on_clicked_listener.dart';
import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:atom_ui/src/ConstantStrings.dart';
import 'package:atom_ui/widgets/round_corner_button.dart';
import 'package:atom_ui/widgets/text_field_with_round_corner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QtyInputDialog extends StatefulWidget {
  final OnClickCallBack<int> onSaveClicked;
  late int? initValue;

  QtyInputDialog({Key? key, required this.onSaveClicked, this.initValue})
      : super(key: key);

  @override
  State<QtyInputDialog> createState() => _QtyInputDialogState();
}

class _QtyInputDialogState extends State<QtyInputDialog> {
  late TextEditingController _qtyAddTextFieldController;
  late String? errorMessage;
  late bool _validInput = true;

  @override
  void initState() {
    super.initState();
    _qtyAddTextFieldController = TextEditingController();
    _qtyAddTextFieldController.text =
        widget.initValue == null ? '' : widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(ConstantDimens.smallPadding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldWithRoundCorner(
                  labelText: ConstantString.qty,
                  textEditingController: _qtyAddTextFieldController,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  inputType: TextInputType.number,
                  errorMessage:
                      _validInput ? null : ConstantString.requiredTextFormField,
                ),
                SizedBox(height: ConstantDimens.padding),
                RoundCornerButton('Save', () {
                  if (_qtyAddTextFieldController.text.trim().isEmpty) {
                    hideErrorMessage(false);
                  } else {
                    hideErrorMessage(true);
                    widget.onSaveClicked
                        .call(int.parse(_qtyAddTextFieldController.text));
                    Navigator.pop(context);
                  }
                }, height: 50, width: 65)
              ]),
        ),
      ),
    );
  }

  hideErrorMessage(bool isValid) {
    setState(() {
      _validInput = isValid;
    });
  }
}
