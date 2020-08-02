import 'package:flutterdeviceinventory/Model/HomePageModel.dart';
import 'package:flutterdeviceinventory/View/HomePageView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Presenter {
  set setView(HomePageView value) {}
  void onListTileOnTap(int index) {}
}

class MyHomePagePresenter implements Presenter {
  HomePageView _homepageView;
  HomePageModel _model;
  MyHomePagePresenter() {
    _model = HomePageModel();
  }

  @override
  void set setView(HomePageView value) {
    _homepageView = value;
    _homepageView.refreshState(_model);
  }

  @override
  void onListTileOnTap(int index) async {
    String user = _model.users[index];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(user);
    prefs.setString('user', user);
  }
}
