import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class Bluetooth {
  static const String _cameraPrefix = 'cam';

  static Future<void> scanForDevices() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();

    Set<BluetoothDiscoveryResult> allDevices = await FlutterBluetoothSerial.instance.startDiscovery().toSet();
    Map<String, BluetoothDiscoveryResult> deviceMap = {};
    allDevices.where((res) => res.device.name != null && res.device.name!.startsWith(_cameraPrefix)).forEach((res) {
      deviceMap[res.device.address] = res;
    });
    Set<BluetoothDiscoveryResult> cameraDevices = deviceMap.values.toSet();

    debugPrint("ALL BLUETOOTH DEVICES");
    for (BluetoothDiscoveryResult res in allDevices) {
      debugPrint(res.device.name);
    }

    debugPrint("CAMERA BLUETOOTH DEVICES");
    for (BluetoothDiscoveryResult res in cameraDevices) {
      debugPrint(res.device.name);
    }

    /*BluetoothConnection connection = await BluetoothConnection.toAddress(deviceMap.keys.first);
    connection.output.add(utf8.encode("Home"));
    await connection.output.allSent;

    List<int> data = [];
    connection.input?.listen((List<int> data) {
      data.addAll(data);
    });

    //await Future.delayed(const Duration(seconds: 5));

    List<String> deviceData = utf8.decode(data).split(" ");
    String deviceID = deviceData[0];
    String deviceIP = deviceData[1];
    debugPrint("DEVICE ID:$deviceID");
    debugPrint("DEVICE IP:$deviceIP");

    await connection.close();*/
    //TODO loading and context location bluetooth message

  }


}
