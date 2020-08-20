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
  void saveDeviceData(
      {String deviceName,
      String osVersion,
      String display,
      String ram,
      String processor,
      String platform}) {
    _auth.saveDeviceData(
        deviceName: deviceName,
        osVersion: osVersion,
        display: display,
        ram: ram,
        processor: processor,
        platform: platform);
    _view.successfulDialog();
  }
}
