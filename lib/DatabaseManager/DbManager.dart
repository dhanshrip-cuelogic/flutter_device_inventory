import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Model/EmployeeModel.dart';

class DbManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
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

  Future saveEmployeeData({String email, String cueid, String username}) {
    Employee employee = Employee(email, cueid, username);
    _database.reference().child('Employee').push().set(employee.toJson());
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
      print('Here is the deviceList from dbmanager----------------$deviceList');
    });

//    StreamSubscription<Event> onUpdateDevices = _database
//        .reference()
//        .child('AndroidDevices')
//        .onChildChanged
//        .listen((event) {});

    return deviceList;
  }
}
