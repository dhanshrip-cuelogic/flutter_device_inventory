import 'package:firebase_database/firebase_database.dart';

class Device {
  String key;
  String deviceName;
  String osVersion;
  String status;

  Device(this.deviceName, this.osVersion, this.status);

  Device.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        deviceName = snapshot.value["deviceName"],
        osVersion = snapshot.value["osVersion"],
        status = snapshot.value["status"];

  toJson() {
    return {
      "deviceName": deviceName,
      "osVersion": osVersion,
      "status": status,
    };
  }
}
