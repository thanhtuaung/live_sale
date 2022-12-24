import 'package:flutter/material.dart';

class MoneyRow extends StatelessWidget {
  final String name;
  final String ammout;

  const MoneyRow({Key? key, required this.name, required this.ammout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith()),
        Expanded(child: DashedLine()),
        Expanded(
            child: Align(alignment: Alignment.topRight, child: _price(context)))
      ],
    );
  }

  Widget _price(BuildContext context) {
    return RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
            text: "",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(),
            children: [
              TextSpan(
                text: ammout,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(),
              )
            ]));
  }
}

class DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Row(
          children: List.generate(dashCount, (_) {
            return Text(" ");
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }
}
