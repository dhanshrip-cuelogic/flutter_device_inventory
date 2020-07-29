import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

//  DeviceDetailsPresenter _deviceDetailsPresenter = DeviceDetailsPresenter();
  StreamSubscription<Event> onUpdateDevices;

  Future signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

//  Future<void> sendEmailVerification() async {
//    FirebaseUser user = await _firebaseAuth.currentUser();
//    user.sendEmailVerification();
//  }

  Future<bool> isEmailVerified(FirebaseUser user) async {
    return user.isEmailVerified;
  }

  Future saveEmployeeData(
      {String userid, String email, String cueid, String username}) {
    Employee employee = Employee(email, cueid, username);
    _database
        .reference()
        .child('Employee')
        .child(userid)
        .set(employee.toJson());
  }

  Future saveDeviceData({String deviceName, String osVersion}) {
    var status = 'Available';
    Device device = Device(deviceName, osVersion, status);
    _database.reference().child('AndroidDevices').push().set(device.toJson());
  }

  Future<List<Device>> fetchDevices() async {
    List<Device> deviceList = new List();
    Query _devices =
        await _database.reference().child('AndroidDevices').orderByKey();

    StreamSubscription<Event> onAddedDevices = _database
        .reference()
        .child('AndroidDevices')
        .onChildAdded
        .listen((event) {
      deviceList.add(Device.fromSnapshot(event.snapshot));
    });

//    StreamSubscription<Event> onUpdateDevices = _database
//        .reference()
//        .child('AndroidDevices')
//        .onChildChanged
//        .listen((event) {});

    return deviceList;
  }

  void updateDevice({Device device, String key}) {
    _database
        .reference()
        .child('AndroidDevices')
        .child(key)
        .set(device.toJson());
  }

  bool deleteDevice({String key}) {
    _database
        .reference()
        .child('AndroidDevices')
        .child(key)
        .remove()
        .then((value) => true);
  }

  Future<List<List<Device>>> fetchIssuedDevices() async {
    List<Device> availableList = new List();
    List<Device> issuedList = new List();
    Query _devices =
        await _database.reference().child('AndroidDevices').orderByKey();

    StreamSubscription<Event> onAddedDevices = _database
        .reference()
        .child('AndroidDevices')
        .onChildAdded
        .listen((event) {
      var device = Device.fromSnapshot(event.snapshot);
      if (device.status == 'Available') {
        availableList.add(Device.fromSnapshot(event.snapshot));
      } else {
        issuedList.add(Device.fromSnapshot(event.snapshot));
      }
    });

    return [availableList, issuedList];
  }

  Future<Employee> getUserInfo(FirebaseUser user) async {
    Employee employee;
    Query _user = await _database
        .reference()
        .child('Employee')
        .orderByChild('email')
        .equalTo(user.email);

    StreamSubscription<Event> onAddedDevice =
        _database.reference().child('Employee').onChildAdded.listen((event) {
      employee = Employee.fromSnapshot(event.snapshot);
    });
    return employee;
  }

  void updateDeviceStatus(String key, String status) {
    _database
        .reference()
        .child('AndroidDevices')
        .child(key)
        .child('status')
        .set(status);
  }

  Future saveCheckIn(String key) async {
    FirebaseUser user = await getCurrentUser();
//    Employee currentUser = await getUserInfo(user);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a, EEE, d MMM y').format(now);

    DeviceHistory device = DeviceHistory(
        deviceKey: key,
        user: user.email,
        checkin: formattedDate,
        checkout: "-- --");

    _database.reference().child('HistoryTable').push().set({device.toJson()});
  }

  Future saveCheckOut(String key) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a, EEE, d MMM y').format(now);

    StreamSubscription<Event> onDevice = _database
        .reference()
        .child('HistoryTable')
        .orderByChild('check-out')
        .equalTo('-- --')
        .onChildAdded
        .listen((event) {
      DeviceHistory device = DeviceHistory.fromSnapshot(event.snapshot);
      print('Now we are fetching chekout data');
      if (device.deviceKey == key) {
        print('Now we will change the checkout date');
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

        return true;
      }
    });
  }

  Future<List<DeviceHistory>> getDeviceHistory(String key) async {
    List<DeviceHistory> history = [];
    StreamSubscription<Event> onDevice = await _database
        .reference()
        .child('HistoryTable')
        .orderByChild('deviceKey')
        .equalTo(key)
        .onChildAdded
        .listen((event) {
      DeviceHistory device = DeviceHistory.fromSnapshot(event.snapshot);
      history.add(device);
    });
    return history;
  }

  @override
  Future<void> resetPassword(String email) async {
    var result = await _firebaseAuth.sendPasswordResetEmail(email: email);
    print('sending verification mail');
    return result;
  }
}
