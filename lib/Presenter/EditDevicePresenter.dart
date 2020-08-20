import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/EditDevice.dart';

class Presenter {
  set setView(EditDeviceView value) {}

  void updateDevice() {}
}

class EditDevicePresenter implements Presenter {
  EditDeviceView _view;
  DbManager _dbManager = DbManager();

  @override
  void set setView(EditDeviceView value) {
    _view = value;
  }

  @override
  void updateDevice(
      {String key,
      String name,
      String osVersion,
      String status,
      String issuedUser,
      String checkin,
      String display,
      String ram,
      String processor,
      String platform}) {
    Device updatedDevice = Device(
        name, osVersion, status, issuedUser, checkin, display, ram, processor);
    _dbManager.updateDevice(
        key: key, device: updatedDevice, platform: platform);
  }
}
