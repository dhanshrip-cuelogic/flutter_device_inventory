import 'package:flutterdeviceinventory/View/AddDevice.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';

class Presenter {
  set setView(AddDeviceView value) {}
  void saveDeviceData() {}
}

class AddDevicePresenter implements Presenter {
  DbManager _auth = DbManager();
  AddDeviceView _view;

  @override
  void set setView(AddDeviceView value) {
    _view = value;
  }

  @override
  void saveDeviceData({String deviceName, String osVersion}) {
    _auth.saveDeviceData(deviceName: deviceName, osVersion: osVersion);
    print('Data has been sent to save on database');
  }
}
