import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';

class Presenter {
  set setView(DeviceDetailsView value) {}

  void doCheckIn(String key) {}
}

class DeviceDetailsPresenter implements Presenter {
  DbManager _dbManager = DbManager();
  DeviceDetailsView _view;

  @override
  void set setView(DeviceDetailsView value) {
    _view = value;
  }

  @override
  void doCheckIn(String key) {
    _dbManager.saveCheckIn(key).then((value) {
      _dbManager.updateDeviceStatus(key, 'Issued');
      _view.changeToCheckout(key: key);
    });
  }

  void doCheckOut(String key) async {
    bool markedCheckout = await _dbManager.saveCheckOut(key);
//    if (value == true) {
//      print('Time to change checkout');
//      _dbManager.updateDeviceStatus(key, "Available");
//      _view.changeToCheckin(key: key);
//    } else {
//      print('Not changing now....');
//      _view.circularIndicator();
//    }
  }
}
