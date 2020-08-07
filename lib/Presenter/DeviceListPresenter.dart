import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/DeviceList.dart';

class Presenter {
  set setView(DeviceListView value) {}
  void deleteDevice(
      String key, int index, String platform, DeviceListView view) {}
  void childAddedEvent(Event event) {}
  void childUpdatedEvent(Event event) {}
}

class DeviceListPresenter implements Presenter {
  DeviceListView _view;
  DbManager _dbManager = DbManager();
  List<Device> deviceList = [];

  @override
  void set setView(DeviceListView value) {
    _view = value;
  }

  @override
  void deleteDevice(
      String key, int index, String platform, DeviceListView view) {
    _dbManager.deleteDevice(key: key, platform: platform);
    view.removeDevice(index);
  }

  @override
  void childAddedEvent(Event event) {
    Device device = (Device.fromSnapshot(event.snapshot));
    deviceList.add(device);
    _view.refreshState(deviceList);
  }

  @override
  void childUpdatedEvent(Event event) {
    Device device = (Device.fromSnapshot(event.snapshot));
    print(device.deviceName);
    _view.updateDeviceList(device);
  }
}
