import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/DeviceList.dart';

class Presenter {
  set setView(DeviceListView value) {}
  Future fetchDeviceData(String platform) {}
  void deleteDevice(String key, int index, String platform) {}
  void presenterDispose() {}
}

class DeviceListPresenter implements Presenter {
  DeviceListView _view;
  DbManager _dbManager = DbManager();
  StreamSubscription<Event> devicesEvent;
  StreamSubscription<Event> devicesChangeEvent;

  @override
  void set setView(DeviceListView value) {
    _view = value;
  }

  @override
  Future fetchDeviceData(String platform) async {
    List<Device> deviceList = [];
    _dbManager.fetchDevices(platform).then((value) {
      Query query = value;
      devicesEvent = query.onChildAdded.listen((event) {
        Device device = (Device.fromSnapshot(event.snapshot));
        deviceList.add(device);
        _view.refreshState(deviceList);
      });

      devicesChangeEvent = query.onChildChanged.listen((event) {
        Device device = (Device.fromSnapshot(event.snapshot));
        print(device.deviceName);
        _view.updateDeviceList(device);
      });
    });

//    Map<dynamic, dynamic> values = snapshot.value;
//
//    values.forEach((key, value) {
//      devices.add(Device.fromSnapshot(key, value));
//    });
  }

  @override
  void deleteDevice(String key, int index, String platform) {
    _dbManager.deleteDevice(key: key, platform: platform);
    _view.removeDeviceFromList(index);
  }

  @override
  void presenterDispose() {
    devicesChangeEvent.cancel();
    devicesEvent.cancel();
  }
}
