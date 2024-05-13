import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class Bluetooth {
  static const String _cameraPrefix = 'cam';
  static List<BluetoothDevice> availableCameras = [];

  static Future<void> scanForDevices() async {
    List<BluetoothDiscoveryResult> allDevices = [];
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();

    List<BluetoothDiscoveryResult> cameraDevices = allDevices.where((res) =>
        res.device.name!.startsWith(_cameraPrefix)).toList();

    debugPrint("ALL BLUETOOTH DEVICES");
    for (BluetoothDiscoveryResult res in allDevices) {
      debugPrint(res.device.name);
    }

    debugPrint("CAMERA BLUETOOTH DEVICES");
    for (BluetoothDiscoveryResult res in cameraDevices) {
      debugPrint(res.device.name);
    }

    //BluetoothConnection connection = await BluetoothConnection.toAddress(esp32.address);
  }


}
