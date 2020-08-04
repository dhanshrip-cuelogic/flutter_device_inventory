import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Model/EmployeeModel.dart';
import 'package:flutterdeviceinventory/Model/DeviceHistory.dart';
import 'package:intl/intl.dart';

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class DbManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future signIn(String email, String password) async {
    String errorMessage;
    FirebaseUser user;

    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND':
          errorMessage = "User not found";
          break;

        case 'ERROR_WRONG_PASSWORD':
          errorMessage = "The password is invalid";
          break;

        case 'ERROR_NETWORK_REQUEST_FAILED':
          errorMessage = "A network error has occurred. Please try again.";
          break;
      }
      throw errorMessage;
    }

    return user;
  }

  Future signUp(String email, String password) async {
    String errorMessage;
    FirebaseUser user;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } on PlatformException catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email already in use.";
          break;

        case 'ERROR_NETWORK_REQUEST_FAILED':
          errorMessage = "A network error has occurred. Please try again.";
          break;
      }

      throw errorMessage;
    }

    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future resetPassword(String email) async {
    var result = await _firebaseAuth.sendPasswordResetEmail(email: email);
    return result;
  }

  Future<bool> isEmailVerified(FirebaseUser user) async {
    return user.isEmailVerified;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  //  Add new Employee into database.

  Future saveEmployeeData(
      {String userid, String email, String cueid, String username}) {
    Employee employee = Employee(email, cueid, username);
    _database
        .reference()
        .child('Employee')
        .child(userid)
        .set(employee.toJson());
  }

  //   Add new device into database.

  Future saveDeviceData(
      {String deviceName, String osVersion, String platform}) {
    var status = 'Available';
    Device device = Device(deviceName, osVersion, status);
    if (platform == "Android") {
      _database.reference().child('AndroidDevices').push().set(device.toJson());
    } else {
      _database.reference().child('iOSDevices').push().set(device.toJson());
    }
  }

  //   Fetching devices from firebase

  Future fetchDevices(String platform) async {
    var snapshot;
    if (platform == "Android") {
      snapshot =
          await _database.reference().child('AndroidDevices').orderByKey();
    } else {
      snapshot = await _database.reference().child('iOSDevices').orderByKey();
    }
    return snapshot;
  }

  //  Update device data by Admin

  void updateDevice({Device device, String key, String platform}) {
    if (platform == "Android") {
      _database
          .reference()
          .child('AndroidDevices')
          .child(key)
          .set(device.toJson());
    } else {
      _database.reference().child('iOSDevices').child(key).set(device.toJson());
    }
  }

  //  Delete device data by Admin

  bool deleteDevice({String key, String platform}) {
    if (platform == "Android") {
      _database.reference().child('AndroidDevices').child(key).remove();
    } else {
      _database.reference().child('iOSDevices').child(key).remove();
    }
  }

  //  Update device status after check-in or check-out

  void updateDeviceStatus(String key, String status, String platform) {
    if (platform == "Android") {
      _database
          .reference()
          .child('AndroidDevices')
          .child(key)
          .child('status')
          .set(status);
    } else {
      _database
          .reference()
          .child('iOSDevices')
          .child(key)
          .child('status')
          .set(status);
    }
  }

  //   Save check-in time of device with user.

  Future saveCheckIn(String key) async {
    FirebaseUser user = await getCurrentUser();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a, EEE, d MMM y').format(now);

    DeviceHistory device = DeviceHistory(
        deviceKey: key,
        user: user.email,
        checkin: formattedDate,
        checkout: "-- --");

    _database.reference().child('HistoryTable').push().set(device.toJson());
  }

  //   Save check-out time of device with user.

  void saveCheckOut(String key) async {
    bool isDone = false;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a, EEE, d MMM y').format(now);

    StreamSubscription<Event> _onDevice = await _database
        .reference()
        .child('HistoryTable')
        .orderByChild('check-out')
        .equalTo('-- --')
        .onChildAdded
        .listen((event) {
      DeviceHistory device = DeviceHistory.fromSnapshot(event.snapshot);
      if (device.deviceKey == key) {
        DeviceHistory newDevice = DeviceHistory(
            deviceKey: device.deviceKey,
            user: device.user,
            checkin: device.checkin,
            checkout: formattedDate);

        _database
            .reference()
            .child('HistoryTable')
            .child(device.key)
            .set(newDevice.toJson());
      }
    });
  }

  Future getDeviceHistory(String key) async {
    return await _database
        .reference()
        .child('HistoryTable')
        .orderByChild('deviceKey')
        .equalTo(key);
//        .onChildAdded
//        .listen((event) {
//      DeviceHistory device = DeviceHistory.fromSnapshot(event.snapshot);
//      history.add(device);
//    })
  }

  Future<bool> checkUser(String user, String email) async {
    if (user == "Admin") {
      // check user from Admin Table
      var snapshot = await _database
          .reference()
          .child("Admin")
          .orderByChild("email")
          .equalTo(email)
          .once();
      if (snapshot.value == null) {
        return false;
      } else {
        return true;
      }
    } else if (user == "Employee") {
      // Check user from Employee Table
      var snapshot = await _database
          .reference()
          .child("Employee")
          .orderByChild("email")
          .equalTo(email)
          .once();
      if (snapshot.value == null) {
        return false;
      } else {
        return true;
      }
    }
  }

  Future getIssuedUser(String key) async {
    var snapshot = await _database
        .reference()
        .child('HistoryTable')
        .orderByChild("check-out")
        .equalTo("-- --");
    return snapshot;
  }
}
