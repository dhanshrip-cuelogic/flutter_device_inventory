import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/DeviceList.dart';

class Presenter {
  set setView(DeviceListView value) {}
  void fetchDeviceData() {}
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
    print('Here is the deviceList----------------$devicesList');
    _view.refreshState(devicesList);
  }
}
