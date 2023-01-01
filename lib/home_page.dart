import 'dart:async';
import 'dart:convert';

import 'package:atom_ui/dialogs/show_circular_progress_dialog.dart';
import 'package:atom_ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:live_sale/bloc/login/cubit/login_cubit.dart';
import 'package:live_sale/bloc/product_fetch/product_fetch_cubit.dart';
import 'package:live_sale/devicesList.dart';
import 'package:live_sale/setting_page.dart';
import 'package:live_sale/widgets/show_host_edit_bottom_sheet.dart';
import 'package:live_sale/wifi_p2p.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import 'bloc/session_check/session_check_cubit.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? _messageReaderStream;
  ShowCircularProgressDialog? showCircularProgressDialog;
  late ValueNotifier<double> _notifier;
  late ProductFetchCubit _productFetchCubit;
  final WifiP2PConnectionUtils _wifiP2PConnectionUtils =
      WifiP2PConnectionUtils();
  final String wifiName = 'wifi_name';
  bool needToClearDialog = false;
  String? hostname;

  @override
  void initState() {
    checkPermission();
    _notifier = ValueNotifier<double>(0.0);
    _check();
    _productFetchCubit = context.read<ProductFetchCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _wifiP2PConnectionUtils.stopHost();
    _wifiP2PConnectionUtils.stopBrowse();
    _messageReaderStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hostRunning = _wifiP2PConnectionUtils.hostRunning;
    return BlocConsumer<SessionCheckCubit, SessionCheckState>(
      listener: ((context, state) {
        if (state is SessionCheckFail) {
          showHostNameInputBottomSheet(context,
                  hostname: 'Marigold Live Room 1')
              .then((value) {
            if (value != null) {
              context.read<SessionCheckCubit>().giveSuccess(value);
            }
          });
        }
      }),
      builder: (context, state) {
        if (state is SessionCheckSuccess) {
          hostname = state.wifiName;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(hostname ?? 'Marigold live'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, settingRoute)
                      .then((value) => _check());
                },
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DevicesListScreen(
                          deviceName: hostname ?? 'Marigold live',
                          deviceType: DeviceType.advertiser,
                        ),
                      ));
                },
                icon: const Icon(Icons.wifi),
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Image.asset('assets/h.jpg', fit: BoxFit.cover),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: const AssetImage('assets/hotspot.png'),
                        child: SimpleCircularProgressBar(
                          animationDuration: 2,
                          backColor: Colors.blueGrey,
                          backStrokeWidth: 8,
                          progressStrokeWidth: 8,
                          valueNotifier: _notifier,
                          mergeMode: true,
                          size: 150,
                          progressColors: const [Colors.pink],
                        ),
                      ),
                      onTap: () => _hostChanger(hostRunning),
                    ),
                    BlocListener<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginLoading) {
                          showCircularProgressDialog =
                              ShowCircularProgressDialog(context);
                        }
                        if (state is LoginSuccess) {
                          // ProductApiRepo()
                          //     .getProduct('0000000029247')
                          //     .then((value) {
                          //   print(value);
                          //   print(DateTime.now());
                          // });
                          // _productFetchCubit.productFetch('0000000029247');
                          if (hostname == null) Navigator.pop(context);
                          closeDialog(context);
                          if (hostname == null) {
                            showHostNameInputBottomSheet(context,
                                    hostname: 'Marigold Live Room 1')
                                .then((value) {
                              if (value != null) {
                                context
                                    .read<SessionCheckCubit>()
                                    .giveSuccess(value);
                              }
                            });
                          }
                        }
                        if (state is LoginFail) {
                          Navigator.pop(context);
                          closeDialog(context);
                          showSnackBar(
                            context,
                            'Choose Database and login again',
                            isError: true,
                          );

                          Navigator.pushNamed(context, settingRoute)
                              .then((value) => _check());
                        }
                      },
                      child: const SizedBox(height: 8),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder:
                          (BuildContext context, double value, Widget? child) {
                        if (value >= 100) {
                          Future.delayed(
                                  const Duration(seconds: 2, milliseconds: 200))
                              .then(
                            (value) {
                              if (!hostRunning) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DevicesListScreen(
                                        deviceName: hostname ?? '',
                                        deviceType: DeviceType.advertiser),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                  _messageReaderStream = _wifiP2PConnectionUtils
                                      .nearbyService
                                      .dataReceivedSubscription(
                                    callback: (data) {
                                      // _showToast(data['message'] ?? '');
                                      if (data['message'] == 'test') {
                                        if (needToClearDialog) {
                                          Navigator.pop(context);
                                        }
                                        showDialog(
                                            context: context,
                                            builder: (context) => _showDialog({
                                                  'name': '00000000000',
                                                  'product_id': [0, 'Product'],
                                                  'private_price': 'TEST_02222',
                                                  'price_per_kg': 2000.0,
                                                  'list_price': 200000,
                                                }, true));
                                      } else {
                                        _productFetchCubit
                                            .productFetch(data['message']);
                                      }
                                    },
                                  );
                                });
                              }
                            },
                          );
                        }
                        return Container();
                      },
                      child: Container(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async => _hostChanger(hostRunning),
                      // child: Text(hostRunning ? 'Close Host' : 'Create Host'),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        CircleAvatar(
                            backgroundColor:
                                hostRunning ? Colors.green : Colors.red,
                            radius: 5),
                        const SizedBox(width: 8),
                        Text(hostRunning ? 'Connected' : 'Disconnected')
                      ]),
                    ),
                    BlocListener<ProductFetchCubit, ProductFetchState>(
                      listener: (context, state) {
                        if (state is ProductFetchSuccess) {
                          if (needToClearDialog) {
                            Navigator.pop(context);
                          }
                          showDialog(
                            context: context,
                            builder: (context) =>
                                _showDialog(state.product, state.isBarcode),
                          );
                        }
                      },
                      child: const SizedBox(height: 8),
                    ),
                  ],
                ),
              ),
              // FlutterRipple(
              //   radius: 70,
              //   rippleColor: Colors.blue,
              //   onTap: () {
              //     print("hello");
              //   },
              //   child: const Text("Flutter Ripple"),
              // ),
            ],
          ),
        );
      },
    );
  }

  void closeDialog(BuildContext context) {
    if (showCircularProgressDialog?.isShowingDialog() ?? false) {
      Navigator.pop(context);
    }
  }

  void _check() {
    context.read<SessionCheckCubit>().checkSession();
  }

  Widget _showDialog(Map<String, dynamic> product, bool isBarcode) {
    Widget widg = _createImage(isBarcode, product);

    needToClearDialog = true;

    return Card(
      child: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    needToClearDialog = false;
                  },
                  icon: const Icon(Icons.clear))),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widg,
                  // SizedBox(
                  //   height: Responsive.currentHeight(context) * 0.5,
                  //   width: Responsive.currentWidth(context) * 0.5,
                  //   child: ImageLoaderUtils.getImageUrl(
                  //       height: Responsive.currentHeight(context) * 0.5,
                  //       width: Responsive.currentWidth(context) * 0.5,
                  //       model: 'stock.production.lot',
                  //       imageSizes: 'image',
                  //       lsWriteDate: 'lsWriteDate',
                  //       id: product['id'] ?? 0),
                  // ),
                  // ['product_name', 'image', 'private_price', 'price_per_kg']
                  const SizedBox(height: 8.0),
                  if (product['product_id'] != null)
                    Text(product['product_id'][1],
                        style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8.0),
                  if (product['private_price'] != null &&
                      product['private_price'].runtimeType != bool)
                    Text('Private Price : ${product['private_price']}',
                        style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8.0),
                  if (product['price_per_kg'] != null &&
                      product['price_per_kg'].runtimeType != bool)
                    Text('Price/Kg : ${product['price_per_kg'].toString()}',
                        style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createImage(bool isBarcode, Map<String, dynamic> product) {
    Widget widget;
    // if (isBarcode &&
    //     product['image_1920'] != null &&
    //     product['image_1920'].runtimeType != bool &&
    //     product['image_1920'].toString().length > 10) {
    // widget = Image.memory(
    //   base64Decode(product['image_1920']),
    //   height: Responsive.currentHeight(context) * 0.7,
    //   width: Responsive.currentWidth(context) * 0.7,
    //   errorBuilder: (context, error, stackTrace) => Container(
    //     height: Responsive.currentHeight(context) * 0.7,
    //     width: Responsive.currentWidth(context) * 0.7,
    //     child: Image.asset('assets/gallery.png'),
    //   ),
    // );
    // } else if (!isBarcode &&
    //     product['main_photo'] != null &&
    //     product['main_photo'].runtimeType != bool &&
    //     product['main_photo'].toString().length > 10) {
    //   widget = Image.memory(
    //     base64Decode(product['main_photo']),
    //     height: Responsive.currentHeight(context) * 0.7,
    //     width: Responsive.currentWidth(context) * 0.7,
    //     errorBuilder: (context, error, stackTrace) => Container(
    //       height: Responsive.currentHeight(context) * 0.7,
    //       width: Responsive.currentWidth(context) * 0.7,
    //       child: Image.asset('assets/gallery.png'),
    //     ),
    //   );
    if (product['image'] != null &&
        product['image'].runtimeType != bool &&
        product['image'].toString().length > 10) {
      widget = Image.memory(
        base64Decode(product['image']),
        height: Responsive.currentHeight(context) * 0.7,
        width: Responsive.currentWidth(context) * 0.7,
        errorBuilder: (context, error, stackTrace) => Container(
          height: Responsive.currentHeight(context) * 0.7,
          width: Responsive.currentWidth(context) * 0.7,
          child: Image.asset('assets/gallery.png'),
        ),
      );
    } else {
      widget = Container(
        height: Responsive.currentHeight(context) * 0.7,
        width: Responsive.currentWidth(context) * 0.7,
        child: Image.asset('assets/gallery.png'),
      );
    }
    //
    return widget;
  }

  // _showToast(String message) {
  //   showToast(message,
  //       context: context,
  //       animation: StyledToastAnimation.slideFromTopFade,
  //       reverseAnimation: StyledToastAnimation.slideToTopFade,
  //       position:
  //           const StyledToastPosition(align: Alignment.topCenter, offset: 0.0),
  //       startOffset: const Offset(0.0, -3.0),
  //       reverseEndOffset: const Offset(0.0, -3.0),
  //       duration: const Duration(seconds: 4),
  //       //Animation duration   animDuration * 2 <= duration
  //       animDuration: const Duration(seconds: 1),
  //       curve: Curves.fastLinearToSlowEaseIn,
  //       reverseCurve: Curves.fastOutSlowIn);
  // }

  _hostChanger(bool hostRunning) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((_blueLack) {
      if (_blueLack.contains(AndroidBluetoothLack.bluetoothFunction)) {
        ///turn on bluetooth function
        FlutterBlueElves.instance.androidOpenBluetoothService((isOk) {
          if (!isOk) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Open Location and bluetooth'),
                backgroundColor: Colors.red));
          }
        });
      }
      if (_blueLack.contains(AndroidBluetoothLack.locationFunction)) {
        ///turn on location function
        FlutterBlueElves.instance.androidOpenLocationService((isOk) {
          if (!isOk) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Open Location and bluetooth'),
                backgroundColor: Colors.red));
          }
        });
      }
      if (_blueLack.isEmpty) {
        if (!hostRunning) {
          _wifiP2PConnectionUtils.circularProgress(_notifier);
        } else {
          _wifiP2PConnectionUtils.stopHost();
          _wifiP2PConnectionUtils.stopBrowse();
          _notifier.value = 0.0;
          _notifier.notifyListeners();
          setState(() {});
        }
      }
    });
  }

  void checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.bluetoothScan,
      Permission.bluetooth,
      Permission.nearbyWifiDevices,
    ].request();
    statuses.forEach((key, value) {
      if (value.isDenied && value.isPermanentlyDenied) {
        return;
      }
    });
    if (statuses.values.contains(PermissionStatus.denied)) {
      checkPermission();
    }
  }
}
// FlutterBlueElves.instance.androidCheckBlueLackWhat().then((_blueLack) {
//   if (_blueLack.contains(AndroidBluetoothLack.locationPermission)) {
//     ///apply location permission
//     FlutterBlueElves.instance.androidApplyLocationPermission((isOk) {
//       print(isOk
//           ? "User agrees to grant location permission"
//           : "User does not agree to grant location permission");
//     });
//   }
//
//   if (_blueLack.contains(AndroidBluetoothLack.bluetoothPermission)) {
//     ///turn on bluetooth permission
//     FlutterBlueElves.instance.androidApplyBluetoothPermission((isOk) {
//       print(isOk
//           ? "The user agrees to turn on the Bluetooth permission"
//           : "The user does not agrees to turn on the Bluetooth permission");
//     });
//   }
//
//   if (_blueLack.contains(AndroidBluetoothLack.bluetoothFunction)) {
//     ///turn on bluetooth function
//     FlutterBlueElves.instance.androidOpenBluetoothService((isOk) {
//       print(isOk
//           ? "The user agrees to turn on the Bluetooth function"
//           : "The user does not agrees to turn on the Bluetooth function");
//     });
//   }
//   if (_blueLack.contains(AndroidBluetoothLack.locationFunction)) {
//     ///turn on location function
//     FlutterBlueElves.instance.androidOpenLocationService((isOk) {
//       print(isOk
//           ? "The user agrees to turn on the positioning function"
//           : "The user does not agree to enable the positioning function");
//     });
//   }
// });

/*
  *
  *                                         showToast(data['message'],
                                            context: context,
                                            animation: StyledToastAnimation
                                                .slideFromTopFade,
                                            reverseAnimation:
                                                StyledToastAnimation
                                                    .slideToTopFade,
                                            position: const StyledToastPosition(
                                                align: Alignment.topCenter,
                                                offset: 0.0),
                                            startOffset:
                                                const Offset(0.0, -3.0),
                                            reverseEndOffset:
                                                const Offset(0.0, -3.0),
                                            duration:
                                                const Duration(seconds: 4),
                                            //Animation duration   animDuration * 2 <= duration
                                            animDuration:
                                                const Duration(seconds: 1),
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            reverseCurve: Curves.fastOutSlowIn);
                                            * */
// Text(product['name'], style: const TextStyle(fontSize: 25)),
// const SizedBox(height: 8.0),
// if (product['product_id'] != null)
//   Text(product['product_id'][1],
//       style: const TextStyle(fontSize: 25)),
// const SizedBox(height: 8.0),
// if (isBarcode &&
//     product['list_price'] != null &&
//     product['list_price'].runtimeType != bool)
//   Text('Price : ${product['list_price']}',
//       style: const TextStyle(fontSize: 25)),
// const SizedBox(height: 8.0),
// if (product['private_price'] != null &&
//     product['private_price'].runtimeType != bool)
//   Text('Price : ${product['private_price']}',
//       style: const TextStyle(fontSize: 25)),
