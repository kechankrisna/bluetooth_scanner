class BluetoothDevice {
  String name;
  String address;
  int bonded;
  int type;
  String uuids;

//  BluetoothDevice._internal(this._name, this._address, this._bonded, this._type, this._uuids);
  BluetoothDevice(
      {this.name, this.address, this.bonded, this.type, this.uuids});

  factory BluetoothDevice.fromMap(Map<dynamic, dynamic> map) =>
      BluetoothDevice(
          name: map['name'],
          address: map['address'],
          bonded: map['bonded']?.runtimeType == String ? int.parse(map['bonded']) : map['bonded'] ,
          type: map['type']?.runtimeType == String ? int.parse(map['type']) : map['type'] ,
          uuids: map['uuids']
      );
}
