import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/View/IssuedDeviceList.dart';

class Presenter {
  set setView(IssuedDeviceView value) {}

  void fetchDevices() {}
}

class IssuedPresenter implements Presenter {
  List deviceList = [];
  IssuedDeviceView _view;
  DbManager _dbManager = DbManager();

  @override
  void set setView(value) {
    _view = value;
  }

  @override
  void fetchDevices() async {
    deviceList = await _dbManager.fetchIssuedDevices();
    _view.refreshState(deviceList[0], deviceList[1]);
  }
}
