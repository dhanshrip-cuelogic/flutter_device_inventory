import 'package:flutterdeviceinventory/Model/PlatformSelectionModel.dart';
import 'package:flutterdeviceinventory/View/PlatformSelectionPage.dart';

class Presenter {
  set setView(PlatformSelectionView value) {}
}

class PlatformSelectionPresenter implements Presenter {
  PlatformSelectionView _view;
  PlatformSelectionModel _model;

  PlatformSelectionPresenter() {
    _model = PlatformSelectionModel();
  }

  @override
  void set setView(value) {
    _view = value;
    _view.refreshState(_model);
  }
}
