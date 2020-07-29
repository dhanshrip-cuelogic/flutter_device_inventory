import 'package:firebase_database/firebase_database.dart';

class DeviceHistory {
  String key;
  String deviceKey;
  String user;
  String checkin;
  String checkout;

  DeviceHistory({this.deviceKey, this.user, this.checkin, this.checkout});

  DeviceHistory.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        deviceKey = snapshot.value["deviceKey"],
        user = snapshot.value["user"],
        checkin = snapshot.value["check-in"],
        checkout = snapshot.value["check-out"];

  toJson() {
    return {
      "deviceKey": deviceKey,
      "user": user,
      "check-in": checkin,
      "check-out": checkout,
    };
  }
}
