import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:flutter/material.dart';

class DateRangePickerBtnWidget extends StatefulWidget {
  DateRangePickerBtnWidget({Key? key}) : super(key: key);

  @override
  State<DateRangePickerBtnWidget> createState() =>
      _DateRangePickerBtnWidgetState();
}

class _DateRangePickerBtnWidgetState extends State<DateRangePickerBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateRangePickerDialog dialog = await DateRangePickerDialog(
            firstDate: DateTime(2021, 7, 1), lastDate: DateTime.now());
        DateTimeRange range =
            await showDialog(context: context, builder: (context) => dialog);
      },
      child: Container(
        height: ConstantDimens.app_bar_size,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.green),
        ),
        child: Text(''),
      ),
    );
  }
}
