import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:flutter/material.dart';

class SearchByQRCodeWidget extends StatelessWidget {
  late bool? showHorizontal;
  final VoidCallback onClick;
  final String label;

  SearchByQRCodeWidget(
      {Key? key,
      this.showHorizontal = true,
      required this.onClick,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstantDimens.padding),
          border: Border.all(width: 1, color: Colors.deepOrange)),
      width: ConstantDimens.qrCodeWidgetWidth,
      height: ConstantDimens.qrCodeWidgetHeight,
      // child: Text(label),
      child: Material(
        borderRadius: BorderRadius.circular(ConstantDimens.padding),
        child: InkWell(
          borderRadius: BorderRadius.circular(ConstantDimens.padding),
          onTap: onClick,
          child: showHorizontal! ? _showRow() : _showColumn(),
        ),
      ),
    );
  }

  _showRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(label),
          SizedBox(
            width: ConstantDimens.smallPadding,
          ),
          Icon(Icons.qr_code_scanner)
        ],
      ),
    );
  }

  _showColumn() {
    return Column(
      children: [
        Text(label),
        SizedBox(
          width: ConstantDimens.smallPadding,
        ),
        Icon(Icons.qr_code_scanner)
      ],
    );
  }
}
