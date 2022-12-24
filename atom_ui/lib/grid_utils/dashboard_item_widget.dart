import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:atom_ui/widgets/memory_asset_image_view.dart';
import 'package:flutter/material.dart';

class GridDashboardItem extends StatelessWidget {
  final String title;
  final String image;
  late bool isClickListenerEnable;
  late VoidCallback? onClickCallBack;

  GridDashboardItem(
      {Key? key,
      required this.title,
      required this.image,
      this.onClickCallBack})
      : super(key: key) {
    this.isClickListenerEnable = onClickCallBack != null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (this.isClickListenerEnable) {
          this.onClickCallBack?.call();
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 10.0,
              child: MemoryAssetImage(
                memoryImage: image,
              ),
            ),
            SizedBox(height: ConstantDimens.smallPadding),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
