import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bluetooth_scanner/bluetooth_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isEnable = false;

  List<BluetoothDevice> _devices = List<BluetoothDevice>();

  @override
  void initState() {
    super.initState();
    _isEnableBluetooth();
  }

  Future<void> _isEnableBluetooth() async {
    bool result = await BluetoothScanner.isEnable;
    setState(() => _isEnable = result);
  }

  Future<void> _enableBluetooth() async {
    var result = await BluetoothScanner.enable;
    setState(() => _isEnable = true);
  }

  Future<void> _disableBluetooth() async {
    var result = await BluetoothScanner.disable;
    setState(() => _isEnable = false);
  }

  Future<void> _getBondedDevice() async {
    bool discover = await BluetoothScanner.startDiscovery;
    List<BluetoothDevice> devices = await BluetoothScanner.getBondedDevice;
    setState(() => _devices = devices);
  }

  Future<void> _writeTest() async {
    bool cancel = await BluetoothScanner.cancelDiscovery;
    bool connect = await BluetoothScanner.connect;
    var result = await BluetoothScanner.write;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: ListView.separated(
                itemBuilder: (_, i) => ListTile(
                  title: Text("${_devices[i].name} ${_devices[i].bonded} ${_devices[i].type}"),
                  subtitle: Text("${_devices[i].address}"),
                  onTap: () {
                    _writeTest();
                  },
                ),
                separatorBuilder: (_, i) => Divider(),
                itemCount: _devices.length)),
        floatingActionButton:  Container(
            constraints: BoxConstraints(maxHeight: 60),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(width: 15),
                RaisedButton(
                  onPressed: () {
                    _enableBluetooth();
                  },
                  child: Text("TURN ON"),
                ),
                SizedBox(width: 15),
                RaisedButton(
                  onPressed: () {
                    _disableBluetooth();
                  },
                  child: Text("TURN OFF"),
                ),
                SizedBox(width: 15),
                RaisedButton(
                  onPressed: () {
                    _getBondedDevice();
                  },
                  child: Text("GET BONDED"),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
