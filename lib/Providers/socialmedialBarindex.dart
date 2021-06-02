import 'package:flutter/cupertino.dart';

class BarIndexChange with ChangeNotifier {
  int barIndex = 0;

  String selectedid;
  String selectedmessage;
  bool isselected = false;

  void setBarindex(int index) {
    barIndex = index;
    notifyListeners();
  }

  void setSelectgesture(
      String selectedid, String selectedmessage, bool isSelected) {
    this.selectedid = selectedid;
    this.selectedmessage = selectedmessage;
    this.isselected = isSelected;
    notifyListeners();
  }
}
