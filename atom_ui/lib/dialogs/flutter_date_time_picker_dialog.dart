// import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
//
// showDatePickerDialog(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (_) => DateTimePickerDialog(initDateTime: DateTime.now()));
// }
//
// class DateTimePickerDialog extends StatelessWidget {
//   final DateTime initDateTime;
//
//   DateTimePickerDialog({Key? key, required this.initDateTime})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 20,
//       child: Column(
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                 child: DatePickerWidget(
//                   looping: false,
//                   // default is not looping
//                   firstDate: DateTime.now(),
//                   //DateTime(1960),
//                   //  lastDate: DateTime(2002, 1, 1),
// //              initialDate: DateTime.now(),// DateTime(1994),
//                   dateFormat:
//                       // "MM-dd(E)",
//                       "dd/MMMM/yyyy",
//                   //     locale: DatePicker.localeFromString('he'),
//                   onChange: (DateTime newDate, _) {
//                     print(newDate);
//                   },
//                   pickerTheme: DateTimePickerTheme(
//                     itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
//                     dividerColor: Colors.blue,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 8,
//               ),
//               Expanded(
//                 child: TimePickerSpinner(
//                   is24HourMode: false,
//                   normalTextStyle:
//                       TextStyle(fontSize: 24, color: Colors.deepOrange),
//                   highlightedTextStyle:
//                       TextStyle(fontSize: 24, color: Colors.yellow),
//                   spacing: 50,
//                   itemHeight: 80,
//                   isForce2Digits: true,
//                   onTimeChange: (time) {
//                     print(time);
//                   },
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
