import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:atom_ui/widgets/responsive.dart';
import 'package:flutter/widgets.dart';

class GridUtils {
  static SliverGridDelegate createSliverDelicate(
      BuildContext context, double gridItemWidth, double gridItemHeight) {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            (Responsive.currentWidth(context) ~/ gridItemWidth).toInt(),
        childAspectRatio: Responsive.isMobile(context)
            ? gridItemWidth / gridItemWidth
            : gridItemWidth / gridItemHeight,
        crossAxisSpacing: ConstantDimens.smallPadding,
        mainAxisSpacing: ConstantDimens.smallPadding);
  }

  static SliverGridDelegate createDashboardSliverDelicate(
      BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (Responsive.currentWidth(context) ~/
                ConstantDimens.dashboardGridItemWidth)
            .toInt(),
        childAspectRatio: (150 / 150),
        crossAxisSpacing: ConstantDimens.smallPadding,
        mainAxisSpacing: ConstantDimens.smallPadding);
  }
}
