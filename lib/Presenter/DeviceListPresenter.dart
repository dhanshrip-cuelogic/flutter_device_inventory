import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/DeviceList.dart';

class Presenter {
  set setView(DeviceListView value) {}
  Future fetchDeviceData() {}
  void deleteDevice(String key, int index) {}
}

class DeviceListPresenter implements Presenter {
  DeviceListView _view;
  DbManager _dbManager = DbManager();

  @override
  void set setView(value) {
    _view = value;
  }

  @override
  Future fetchDeviceData() async {
    List<Device> devices = [];

    DataSnapshot snapshot = await _dbManager.fetchDevices();

    Map<dynamic, dynamic> values = snapshot.value;

    values.forEach((key, value) {
      devices.add(Device.fromSnapshot(key, value));
    });

    return devices;
  }

  @override
  void deleteDevice(String key, int index) {
    _dbManager.deleteDevice(key: key);
    _view.removeDeviceFromList(index);
  }
}
