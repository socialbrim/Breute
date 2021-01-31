import 'package:flutter/cupertino.dart';

class BarIndexChange with ChangeNotifier {
  int barIndex = 0;
  void setBarindex(int index) {
    barIndex = index;
    notifyListeners();
  }
}
