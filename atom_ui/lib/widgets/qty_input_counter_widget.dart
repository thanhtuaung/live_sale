import 'package:atom_ui/on_clicked_listener.dart';
import 'package:flutter/material.dart';

class QtyInputCounterWidget extends StatefulWidget {
  final bool? isHorizontal;
  int? counter;
  final OnClickCallBack<int> onPlusClicked;
  final OnClickCallBack<int> onMinusClicked;
  final Color? borderAndBgColor;
  final Color? iconTextColor;
  final Color? counterTextColor;

  QtyInputCounterWidget({
    Key? key,
    this.counter,
    this.isHorizontal = true,
    required this.onPlusClicked,
    required this.onMinusClicked,
    this.borderAndBgColor,
    this.iconTextColor,
    this.counterTextColor,
  }) : super(key: key) {
    if (counter == null) counter = 0;
  }

  @override
  State<QtyInputCounterWidget> createState() => _QtyInputCounterWidgetState();
}

class _QtyInputCounterWidgetState extends State<QtyInputCounterWidget> {
  int counter = 1;
  Color iconTextColor = Colors.white;

  @override
  void initState() {
    counter = widget.counter ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    iconTextColor = widget.iconTextColor ?? Colors.white;
    return widget.isHorizontal!
        ? _container(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _btnMinusCreate(Icons.remove, widget.onMinusClicked),
                SizedBox(width: 8),
                _counterText(),
                SizedBox(width: 8),
                _btnPlusCreate(Icons.add, widget.onPlusClicked),
              ],
            ),
          )
        : _container(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _btnMinusCreate(Icons.remove, widget.onMinusClicked),
                SizedBox(height: 8),
                _counterText(),
                SizedBox(height: 8),
                _btnPlusCreate(Icons.add, widget.onPlusClicked),
              ],
            ),
          );
  }

  Widget _counterText() {
    return CircleAvatar(
        backgroundColor: iconTextColor,
        child: Text(counter.toString(),
            style:
                TextStyle(color: widget.counterTextColor ?? Colors.black87)));
  }

  _container(Widget child) {
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 120, maxWidth: 120),
        child: Container(
          // width: isHorizontal! ? 130 : 56,
          // height: isHorizontal! ? 56 : 130,
          child: child,
          decoration: BoxDecoration(
            color: widget.borderAndBgColor ?? Colors.red,
            border: Border.all(color: widget.borderAndBgColor ?? Colors.red),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _btnPlusCreate(IconData iconData, OnClickCallBack<int> onclick) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Icon(iconData, color: iconTextColor, size: 30),
      onTap: () {
        counter = counter + 1;
        onclick.call(counter);
        setState(() {});
      },
    );
  }

  Widget _btnMinusCreate(IconData iconData, OnClickCallBack<int> onclick) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Icon(iconData, color: iconTextColor, size: 30),
      onTap: () {
        if (counter > 1) {
          counter = counter - 1;
          onclick.call(counter);
        }
        setState(() {});
      },
    );
  }
}
//
// import 'package:flutter/material.dart';
//
// class QtyInputCounterWidget extends StatefulWidget {
//   const QtyInputCounterWidget({Key? key}) : super(key: key);
//
//   @override
//   State<QtyInputCounterWidget> createState() => _QtyInputCounterWidgetState();
// }
//
// class _QtyInputCounterWidgetState extends State<QtyInputCounterWidget> {
//   int _counter = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(
//         maxWidth: 200,
//         maxHeight: 50,
//       ),
//       child: Opacity(
//         // opacity: _isPressed ? 0.5 : 1.0,
//         opacity: 0.5,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: IconButton(
//                 onPressed: _decrement,
//                 icon: const Icon(
//                   Icons.remove,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 onPressed: _increment,
//                 icon: const Icon(
//                   Icons.add,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _increment() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   void _decrement() {
//     setState(() {
//       _counter--;
//     });
//   }
// }
