import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  final String title;
  final String actionName;

  ProgressDialog({Key? key, required this.title, required this.actionName})
      : super(key: key);

  @override
  State<ProgressDialog> createState() => ProgressDialogState();
}

class ProgressDialogState extends State<ProgressDialog> {
  String actionName = '';
  double progressPercent = 0.0;

  changeProgress({required String actionName, required double percentage}) {
    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          this.actionName = actionName;
          this.progressPercent = percentage;
        });
      });
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    actionName = widget.actionName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(ConstantDimens.smallPadding),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ConstantDimens.smallPadding)),
          child: Container(
            padding: EdgeInsets.all(ConstantDimens.smallPadding),
            width: 200,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  child: Center(
                    child: Text(widget.title,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ),
                Container(
                  height: 60,
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.red,
                        color: Colors.purple,
                        value: progressPercent,
                      ),
                      SizedBox(height: ConstantDimens.smallPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${actionName}'),
                          Text('${(progressPercent).toStringAsFixed(2)} %'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
