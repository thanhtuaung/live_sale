import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:live_sale/wifi_p2p.dart';

import 'main.dart';

class DevicesListScreen extends StatefulWidget {
  final String deviceName;

  const DevicesListScreen(
      {Key? key, required this.deviceName, required this.deviceType});

  final DeviceType deviceType;

  @override
  DevicesListScreenState createState() => DevicesListScreenState();
}

class DevicesListScreenState extends State<DevicesListScreen> {
  StreamSubscription? subscription;
  List<Device> connectedDevices = [];
  List<Device> deviceList = [];
  late WifiP2PConnectionUtils _wifiP2PConnectionUtils;

  @override
  void initState() {
    // deviceName =
    //     widget.deviceType == DeviceType.advertiser ? 'Host' : 'Connector';
    _wifiP2PConnectionUtils = WifiP2PConnectionUtils();
    if (!_wifiP2PConnectionUtils.processRunning) {
      _wifiP2PConnectionUtils
          .init(widget.deviceName, widget.deviceType)
          .then((value) {
        _listener(value);
      });
    } else {
      _listener(_wifiP2PConnectionUtils.nearbyService);
      connectedDevices = connectedDeviceList;
    }
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ချိတ်ဆက်ရန်ရှာနေသည်')),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: getItemCount(),
        itemBuilder: (context, index) {
          final device = widget.deviceType == DeviceType.advertiser
              ? connectedDevices[index]
              : deviceList[index];
          connectedDeviceList = connectedDevices;
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Text(device.deviceName),
                            Text(
                              getStateName(device.state),
                              style:
                                  TextStyle(color: getStateColor(device.state)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Request connect
                    GestureDetector(
                      onTap: () => _onButtonClicked(device),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 40,
                        width: 40,
                        color: getButtonColor(device.state),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              getButtonStateIcon(device.state),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Disconnected";
      case SessionState.connecting:
        return "Connecting";
      default:
        return "Connected";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Connect";
      case SessionState.connecting:
        return "Connecting";
      default:
        return "Disconnect";
    }
  }

  IconData getButtonStateIcon(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Icons.link;
      case SessionState.connecting:
        return Icons.autorenew;
      default:
        return Icons.link_off;
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.red;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.green;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return deviceList.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        _wifiP2PConnectionUtils.inviteToPeer(device);
        break;
      case SessionState.connected:
        _wifiP2PConnectionUtils.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void _listener(NearbyService nearbyService) {
    subscription =
        nearbyService.stateChangedSubscription(callback: (deviceListR) {
      for (Device device in deviceListR) {
        if (Platform.isAndroid) {
          if (device.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
      }

      deviceList.clear();
      deviceList.addAll(deviceListR);

      connectedDevices.clear();
      connectedDeviceList = connectedDevices;
      connectedDevices.addAll(
        deviceList.where((d) => d.state == SessionState.connected).toList(),
      );
      setState(() {});
    });
  }
}
