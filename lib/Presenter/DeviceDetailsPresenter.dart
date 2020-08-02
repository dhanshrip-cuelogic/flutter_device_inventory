import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';

class Presenter {
  set setView(DeviceDetailsView value) {}

  void getKey(String key) {}

  void doCheckIn(String key) {}
}

class DeviceDetailsPresenter implements Presenter {
  DbManager _dbManager = DbManager();
  DeviceDetailsView _view;

  @override
  void set setView(DeviceDetailsView value) {
    _view = value;
    // for getting issued user of device.
  }

  @override
  void doCheckIn(String key) {
    try {
      _dbManager.saveCheckIn(key);
      _dbManager.updateDeviceStatus(key, 'Issued');
      _view.changeToCheckout(key: key);
    } catch (error) {
      print("error while doing checkin ------ $error");
    }
  }

  void doCheckOut(String key) async {
    try {
      _dbManager.saveCheckOut(key);
      _dbManager.updateDeviceStatus(key, "Available");
      _view.changeToCheckin(key: key);
    } catch (error) {
      print("error while doing checkout ------ $error");
    }
  }

  @override
  void getKey(String key) {
    _dbManager.getDeviceHistory(key).then((value) {
      print('got value------ $value');
    }, onError: (error) {
      print('got error');
    });
  }
}
