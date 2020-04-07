import 'dart:async';

import 'package:bluetooth_scanner/BluetoothDevice.dart';
import 'package:flutter/services.dart';

class BluetoothScanner {
  static const MethodChannel _channel =
      const MethodChannel('bluetooth_scanner');

  static List<int> _bytes = List<int>();

  //startDiscovery
  static Future<bool> get startDiscovery async {
    final bool result = await _channel.invokeMethod('startDiscovery');
//    print("Result is $result");
    return result;
  }

  //cancelDiscovery
  static Future<bool> get cancelDiscovery async {
    final bool result = await _channel.invokeMethod('cancelDiscovery');
//    print("Result is $result");
    return result;
  }

  //connect
  static Future<bool> get connect async {
    final bool result = await _channel.invokeMethod('connect');
    return result;
  }

  //disconnect
  static Future<String> get disconnect async {
    final String result = await _channel.invokeMethod('disconnect');
    return result;
  }

  //getBondedDevice
  static Future<List<BluetoothDevice>> get getBondedDevice async {
    final List<dynamic> result = await _channel.invokeMethod('getBondedDevice');
//    print(Map.from(result[0]));
    final List<BluetoothDevice> list = result.length > 0
        ? result
            .map((entry) => BluetoothDevice.fromMap(Map.from(entry)))
            .toList()
        : List<BluetoothDevice>();
    return list;
  }

  static setBytes( List<int> bytes ) {
    _bytes = bytes;
  }

  //write
  static Future<String> get write async {


    Map<String, dynamic> map = {"bytes": _bytes};

    final String result = await _channel.invokeMethod('write', map );
    return result;
  }

  //isConnected
  static Future<String> get isConnected async {
    final String result = await _channel.invokeMethod('isConnected');
    return result;
  }

  //isEnable
  static Future<bool> get isEnable async {
    final String result = await _channel.invokeMethod('isEnable');
    print("result = $result");
    return result == "true";
  }

  //enable
  static Future<String> get enable async {
    final String result = await _channel.invokeMethod('enable');
    return result;
  }

  //disable
  static Future<String> get disable async {
    final String result = await _channel.invokeMethod('disable');
    return result;
  }
}
