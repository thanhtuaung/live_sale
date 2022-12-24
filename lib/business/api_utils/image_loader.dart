// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// import '../../src/image_assets.dart';
// import '../../utils/mscm_retail_app.dart';
//
// class ImageLoaderUtils {
//   static Widget getImageUrl(
//       {required String model,
//       required String lsWriteDate,
//       required int id,
//       String? errorImageUrl,
//       // image_256
//       // image_512
//       String? imageSizes = 'image_256',
//       double? width,
//       double? height}) {
//     String unique = lsWriteDate.replaceAll(RegExp(r'[^0-9]'), '');
//     String? sessionID = '';
//     if (MSCMRetail.odooSession != null) {
//       sessionID = MSCMRetail.odooSession?.id;
//       final url =
//           '${MSCMRetail.serverUrl}/web/image?model=$model&field=$imageSizes&id=$id&unique=$unique';
//       return CachedNetworkImage(
//         width: width,
//         height: height,
//         imageUrl: url,
//         httpHeaders: {'Cookie': 'session_id=' + (sessionID ?? '')},
//         errorWidget: (context, url, error) => Container(),
//       );
//     } else {
//       String url = errorImageUrl ??
//           'https://img.freepik.com/premium-vector/404-error-with-icon-tab-wedsite-error_114341-27.jpg';
//       if (url.startsWith('https://')) {
//         return CachedNetworkImage(
//           imageUrl: url,
//           width: width,
//           height: height,
//         );
//       }
//       return Image.asset(
//         ImageAssets.userImage,
//         width: width,
//         height: height,
//       );
//     }
//   }
// }
//
// // return Image.network(
// //   url,
// //   headers: {
// //     'Cookie': 'session_id=' + (sessionID ?? ''),
// //   },
// //   width: width,
// //   height: height,
// // );
