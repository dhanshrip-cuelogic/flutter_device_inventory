import 'package:flutterdeviceinventory/Model/UserData.dart';
import 'package:flutterdeviceinventory/Model/HomePageModel.dart';
import 'package:flutterdeviceinventory/View/HomePageView.dart';

class Presenter {
  set setView(HomePageView value) {}
  void onListTileOnTap(int index) {}
}

class MyHomePagePresenter implements Presenter {
  UserData _userData;
  HomePageView _homepageView;
  HomePageModel _model;

  MyHomePagePresenter() {
    _model = HomePageModel();
    _userData = userData;
  }

  @override
  void set setView(HomePageView value) {
    _homepageView = value;
    _homepageView.refreshState(_model);
  }

  @override
  void onListTileOnTap(int index) {
    _userData.user = _model.users[index];
  }
}
