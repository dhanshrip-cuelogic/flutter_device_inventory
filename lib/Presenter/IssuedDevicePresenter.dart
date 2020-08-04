import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/IssuedDeviceList.dart';

class Presenter {
  set setView(IssuedDeviceView value) {}
  Future fetchDevices(String platform) {}
  void presenterDispose() {}
}

class IssuedPresenter implements Presenter {
  IssuedDeviceView _view;
  DbManager _dbManager = DbManager();
  StreamSubscription<Event> devicesEvent;
  StreamSubscription<Event> devicesChangeEvent;

  @override
  void set setView(value) {
    _view = value;
  }

  @override
  Future fetchDevices(String platform) async {
    var availableList;
    var issuedList;
    List<Device> availableDevices = [];
    List<Device> issuedDevices = [];

    _dbManager.fetchDevices(platform).then((value) {
      Query query = value;

      devicesEvent = query.onChildAdded.listen((event) {
        Device device = (Device.fromSnapshot(event.snapshot));
        if (device.status == "Available") {
          availableDevices.add(device);
          _view.refreshAvailableList(availableDevices);
        } else {
          issuedDevices.add(device);
          _view.refreshIssuedList(issuedDevices);
        }
      });

      devicesChangeEvent = query.onChildChanged.listen((event) {
        Device device = (Device.fromSnapshot(event.snapshot));
        print(device.deviceName);
        _view.updateDeviceList(device);
      });

//      Map<dynamic, dynamic> values = snapshot.value;
//
//      values.forEach((key, value) {
//        deviceLists.add(Device.fromSnapshot(key, value));
//      });
//
//      for (Device device in deviceLists) {
//        if (device.status == "Available") {
//          availableDevices.add(device);
//        } else {
//          issuedDevices.add(device);
//        }
//      }
    });

    availableList = availableDevices;
    issuedList = issuedDevices;

    return [availableList, issuedList];
  }

  @override
  void presenterDispose() {
    devicesEvent.cancel();
    devicesChangeEvent.cancel();
  }
}
