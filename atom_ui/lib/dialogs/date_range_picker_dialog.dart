import 'package:atom_ui/date_time_utils.dart';
import 'package:atom_ui/on_clicked_listener.dart';
import 'package:flutter/material.dart';

class DateRangePickerKDialog extends StatefulWidget {
  final OnClickCallBack<List<DateTime>> callBack;
  late DateTime? firstDate;
  late DateTime? endDate;
  late bool? showClearBtn;
  late VoidCallback? onClear;

  DateRangePickerKDialog(this.callBack,
      {Key? key, this.firstDate, this.endDate, this.showClearBtn, this.onClear})
      : super(key: key) {
    // this.firstDate ??= DateTime(2000, 1, 1);
    // this.endDate ??= DateTime.now();
    this.showClearBtn ??= false;
  }

  @override
  State<DateRangePickerKDialog> createState() => DateRangePickerKDialogState();
}

class DateRangePickerKDialogState extends State<DateRangePickerKDialog> {
  late String inputString;

  final TextEditingController _textFieldController = TextEditingController();

  DateTime? tempFirstDate;
  DateTime? tempEndDate;

  void clear() {
    _textFieldController.clear();
  }

  @override
  void initState() {
    tempFirstDate = widget.firstDate;
    tempEndDate = widget.endDate;
    _resetRange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textFieldController,
      readOnly: true,
      decoration: InputDecoration(
        counterText: "",
        hintText: 'Search by date',
        prefixIcon: Icon(Icons.date_range_rounded),
        suffixIcon:
            widget.showClearBtn! && _textFieldController.text.trim().length > 0
                ? IconButton(
                    icon: Icon(Icons.cancel_outlined),
                    onPressed: () {
                      widget.onClear?.call();
                      _textFieldController.clear();
                      // tempFirstDate = null;
                      // tempEndDate = null;
                      _resetRange();
                      setState(() {});
                    },
                  )
                : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(8.0), left: Radius.circular(8.0))),
      ),
      onTap: () async {
        // if(widget.firstDate != null && widget.endDate != null) {
        // Future.delayed(Duration(milliseconds: 200)).then((value) async {
        DateTimeRange? dateTime = await showDateRangePicker(
            context: context,
            firstDate: widget.firstDate ?? DateTime(2001),
            lastDate: widget.endDate ?? DateTime.now());
        if (dateTime != null &&
            !dateTime.start
                .isAtSameMomentAs(widget.firstDate ?? DateTime.now())) {
          widget.callBack.call([dateTime.start, dateTime.end]);
          inputString =
              '${DateTimeUtils.ddMmYYYFormatSlug.format(dateTime.start)} - ${DateTimeUtils.ddMmYYYFormatSlug.format(dateTime.end)}';
          setState(() {
            _textFieldController.text = inputString;
          });
        }
        // });
      },
    );
  }

  void _resetRange() {
    if (tempFirstDate != null && tempEndDate != null) {
      DateTimeRange dateTime = DateTimeRange(
          start: tempEndDate ?? DateTime.now(),
          end: tempEndDate ?? DateTime.now());
      inputString =
          '${DateTimeUtils.ddMmYYYFormatSlug.format(dateTime.start)} - ${DateTimeUtils.ddMmYYYFormatSlug.format(dateTime.end)}';
      _textFieldController.text = inputString;
      widget.callBack.call([dateTime.start, dateTime.end]);
    } else
      _textFieldController.text = '';
  }
}
