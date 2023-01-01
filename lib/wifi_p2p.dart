import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'main.dart';

enum DeviceType { advertiser, browser }

class WifiP2PConnectionUtils {
  NearbyService? _nearbyService;
  static WifiP2PConnectionUtils? _instance;
  bool processRunning = false;

  factory WifiP2PConnectionUtils() {
    return _instance ??= WifiP2PConnectionUtils._();
  }

  WifiP2PConnectionUtils._();

  bool get hostRunning => processRunning;

  Future<NearbyService> init(String deviceName, DeviceType deviceType) async {
    if (processRunning) {
      _nearbyService!.stopAdvertisingPeer();
      _nearbyService!.stopBrowsingForPeers();
    }
    _nearbyService ??= NearbyService();

    // String devInfo = '';
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   devInfo = androidInfo.model;
    // }
    // if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   devInfo = iosInfo.localizedModel;
    // }
    // print(devInfo);
    await _nearbyService!.init(
      serviceType: '_****_',
      deviceName: deviceName,
      strategy: Strategy.Wi_Fi_P2P,
      // strategy: Strategy.P2P_CLUSTER,
      callback: (isRunning) async {
        if (isRunning) {
          if (deviceType == DeviceType.browser) {
            await _nearbyService!.stopBrowsingForPeers();
            await Future.delayed(const Duration(microseconds: 200));
            await _nearbyService!.startBrowsingForPeers();
          } else {
            await _nearbyService!.stopAdvertisingPeer();
            await _nearbyService!.stopBrowsingForPeers();
            await Future.delayed(const Duration(microseconds: 200));
            await _nearbyService!.startAdvertisingPeer();
            await _nearbyService!.startBrowsingForPeers();
          }
        }
      },
    );
    processRunning = true;
    return _nearbyService!;
  }

  NearbyService get nearbyService {
    if (_nearbyService == null) {
      throw Exception('init method was not called');
    }
    return _nearbyService!;
  }

  void inviteToPeer(Device device) {
    _nearbyService?.invitePeer(
        deviceID: device.deviceId, deviceName: device.deviceName);
  }

  void disconnectPeer({required String deviceID}) {
    _nearbyService?.disconnectPeer(deviceID: deviceID);
  }

  void sendMessage(Device device, {required String message}) {
    _nearbyService?.sendMessage(device.deviceId, message);
  }

  void stopHost() {
    if (connectedDeviceList.isNotEmpty) {
      connectedDeviceList.forEach((element) {
        _nearbyService?.disconnectPeer(deviceID: element.deviceId);
      });
    }
    processRunning = false;
    _nearbyService?.stopAdvertisingPeer();
  }

  void stopBrowse() {
    processRunning = false;
    _nearbyService?.stopBrowsingForPeers();
  }

  Future<void> circularProgress(ValueNotifier<double> notifier) async {
    int i = 0;
    await Future.doWhile(() async {
      await Future.delayed(const Duration(microseconds: 50)).then((value) {
        i++;
        print(i);
        notifier.value = double.parse(i.toString());
      });
      return i < 100;
    });
  }
}
