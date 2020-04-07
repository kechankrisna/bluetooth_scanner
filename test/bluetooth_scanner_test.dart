import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_scanner/bluetooth_scanner.dart';

void main() {
  const MethodChannel channel = MethodChannel('bluetooth_scanner');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startDiscovery', () async {
    expect(await BluetoothScanner.startDiscovery, true);
  });
}
