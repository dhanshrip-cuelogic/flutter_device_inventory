import 'package:firebase_database/firebase_database.dart';

class Device {
  String key;
  String deviceName;
  String osVersion;
  String status;
  String issuedUser;
  String display;
  String ram;
  String processor;
  String checkin;

  Device(this.deviceName, this.osVersion, this.status, this.issuedUser,
      this.checkin, this.display, this.ram, this.processor);

  Device.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        deviceName = snapshot.value["deviceName"],
        osVersion = snapshot.value["osVersion"],
        status = snapshot.value["status"],
        issuedUser = snapshot.value["issuedUser"],
        checkin = snapshot.value["checkin"],
        display = snapshot.value["display"],
        ram = snapshot.value["ram"],
        processor = snapshot.value["processor"];

  toJson() {
    return {
      "deviceName": deviceName,
      "osVersion": osVersion,
      "status": status,
      "issuedUser": issuedUser,
      "checkin": checkin,
      "display": display,
      "ram": ram,
      "processor": processor,
    };
  }
}
