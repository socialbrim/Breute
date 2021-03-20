import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  bool isLoaded = false;
  double savedData = 0.0;
  void setBool(bool bools) {
    isLoaded = bools;
    notifyListeners();
  }
}
