import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/IssuedDeviceList.dart';

class Presenter {
  set setView(IssuedDeviceView value) {}
  Future fetchDevices() {}
}

class IssuedPresenter implements Presenter {
  IssuedDeviceView _view;
  DbManager _dbManager = DbManager();

  @override
  void set setView(value) {
    _view = value;
  }

  @override
  Future fetchDevices() async {
    List<Device> availableDevices = [];
    List<Device> issuedDevices = [];
    List<Device> deviceLists = [];
    DataSnapshot snapshot = await _dbManager.fetchDevices();

    Map<dynamic, dynamic> values = snapshot.value;

    values.forEach((key, value) {
      deviceLists.add(Device.fromSnapshot(key, value));
    });

    for (Device device in deviceLists) {
      if (device.status == "Available") {
        availableDevices.add(device);
      } else {
        issuedDevices.add(device);
      }
    }

    return [availableDevices, issuedDevices];
  }
}
