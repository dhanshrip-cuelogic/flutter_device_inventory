import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/IssuedDeviceList.dart';

class Presenter {
  set setView(IssuedDeviceView value) {}

  void fetchDevices() {}
}

class IssuedPresenter implements Presenter {
  List<Device> deviceList = [];
  List<Device> availableDevices = [];
  List<Device> issuedDevices = [];
  IssuedDeviceView _view;
  DbManager _dbManager = DbManager();

  @override
  void set setView(value) {
    _view = value;
  }

  @override
  void fetchDevices() async {
    deviceList = await _dbManager.fetchDevices();
    _view.refreshState(deviceList);

//    deviceList = await _dbManager.fetchDevices();
//    print('------  After fetching device ....... $deviceList -----');
////    sortDeviceList(deviceList);
//    for (var device in deviceList) {
//      if (device.status == 'Available') {
//        availableDevices.add(device);
//      } else {
//        issuedDevices.add(device);
//      }
//    }
  }
}
