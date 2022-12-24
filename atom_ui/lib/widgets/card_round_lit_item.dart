import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:flutter/material.dart';

class CardRoundListItemWidget extends StatelessWidget {
  final ListTile listTile;
  final Color? bgColor;

  CardRoundListItemWidget(this.listTile, {Key? key, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: bgColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ConstantDimens.smallPadding),
        ),
        child: listTile);
  }
}
