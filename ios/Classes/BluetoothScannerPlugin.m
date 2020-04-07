#import "BluetoothScannerPlugin.h"
#if __has_include(<bluetooth_scanner/bluetooth_scanner-Swift.h>)
#import <bluetooth_scanner/bluetooth_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bluetooth_scanner-Swift.h"
#endif

@implementation BluetoothScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBluetoothScannerPlugin registerWithRegistrar:registrar];
}
@end
