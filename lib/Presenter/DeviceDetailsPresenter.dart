import 'dart:async';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/Model/DeviceHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Presenter {
  set setView(DeviceDetailsView value) {}
  void doCheckIn(Device device, String platform) {}
  void doCheckOut(Device device, String platform) {}
  void getuser(String key, String status) {}
  void presenterDispose() {}
}

class DeviceDetailsPresenter implements Presenter {
  DbManager _dbManager = DbManager();
  DeviceDetailsView _view;
  StreamSubscription<Event> deviceButtonEvent;

  @override
  void set setView(DeviceDetailsView value) {
    _view = value;
  }

  @override
  void doCheckIn(Device device, String platform) {
    try {
      _dbManager.saveCheckIn(device.key);
      _dbManager.updateDeviceStatus(device, 'Issued', platform);
      _view.changeToCheckout();
    } catch (error) {
      print("error while doing checkin ------ $error");
    }
  }

  @override
  void doCheckOut(Device device, String platform) async {
    try {
      _dbManager.saveCheckOut(device.key);
      _dbManager.updateDeviceStatus(device, "Available", platform);
      _view.changeToCheckin();
    } catch (error) {
      print("error while doing checkout ------ $error");
    }
  }

  void getuser(String key, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fetchedUser = prefs.getString('user');

    FirebaseUser currentUser = await _dbManager.getCurrentUser();

    if (fetchedUser == "Employee") {
      if (status == 'Available') {
        _view.changeToCheckin();
        _view.showComplaintButton();
      } else {
        _dbManager.getIssuedUser().then((value) {
          Query query = value;
          deviceButtonEvent = query.onChildAdded.listen((event) {
            DeviceHistory device = DeviceHistory.fromSnapshot(event.snapshot);
            if (device.deviceKey == key) {
              if (device.user == currentUser.email) {
                _view.changeToCheckout();
              } else {
                _view.changeToIssued();
              }
            }
          });
        });
      }
    } else {
      _view.showComplaintButton();
    }
  }

  @override
  void presenterDispose() {
    deviceButtonEvent.cancel();
  }
}
