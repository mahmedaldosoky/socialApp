import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {

  // LinearProgress after clicking update button in edit profile screen
  bool updateLoading = false;

  void startUpdateLoading() {
    updateLoading = true;
    notifyListeners();
  }

  void finishUpdateLoading() {
    updateLoading = false;
    notifyListeners();

  }

  // LinearProgress after clicking Post button in create post screen
  bool postLoading = false;

  void startPostLoading() {
    updateLoading = true;
    notifyListeners();
  }

  void finishPostLoading() {
    updateLoading = false;
    notifyListeners();
  }



}
