import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/DeviceList.dart';

class Presenter {
  set setView(DeviceListView value) {}
  void fetchDeviceData() {}
  void deleteDevice(String key, int index) {}
}

class DeviceListPresenter implements Presenter {
  DeviceListPresenter() {
    _dbManager = DbManager();
  }

  DeviceListView _view;
  DbManager _dbManager;
  List<Device> devicesList;

  @override
  void set setView(value) {
    _view = value;
  }

  @override
  void fetchDeviceData() async {
    devicesList = await _dbManager.fetchDevices();
    _view.refreshState(devicesList);
  }

  @override
  void deleteDevice(String key, int index) {
    _dbManager.deleteDevice(key: key);
    _view.removeDeviceFromList(index);
  }
}
