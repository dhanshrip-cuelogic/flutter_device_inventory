import 'dart:async';

import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/Model/DeviceHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Presenter {
  set setView(DeviceDetailsView value) {}

  void doCheckIn(String key, String platform) {}

  void doCheckOut(String key, String platform) {}
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
    // for getting issued user of device.
  }

  @override
  void doCheckIn(String key, String platform) {
    try {
      _dbManager.saveCheckIn(key);
      _dbManager.updateDeviceStatus(key, 'Issued', platform);
      _view.changeToCheckout(key: key);
    } catch (error) {
      print("error while doing checkin ------ $error");
    }
  }

  @override
  void doCheckOut(String key, String platform) async {
    try {
      _dbManager.saveCheckOut(key);
      _dbManager.updateDeviceStatus(key, "Available", platform);
      _view.changeToCheckin(key: key);
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
        _view.changeToCheckin(key: key);
      } else {
        _dbManager.getIssuedUser(key).then((value) {
          Query query = value;
          deviceButtonEvent = query.onChildAdded.listen((event) {
            DeviceHistory device = DeviceHistory.fromSnapshot(event.snapshot);
            if (device.deviceKey == key) {
              if (device.user == currentUser.email) {
                _view.changeToCheckout(key: key);
              } else {
                _view.changeToIssued();
              }
            }
          });
        });
      }
    }
  }

  @override
  void presenterDispose() {
    deviceButtonEvent.cancel();
  }
}
