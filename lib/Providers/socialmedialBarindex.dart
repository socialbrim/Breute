import 'package:flutter/cupertino.dart';

class BarIndexChange with ChangeNotifier {
  int barIndex = 0;

  String selectedid;
  String selectedmessage;
  bool isselected = false;
  bool issendbyMe = false;

  void setBarindex(int index) {
    barIndex = index;
    notifyListeners();
  }

  void setSelectgesture(String selectedid, String selectedmessage,
      bool isSelected, bool issendbyMe) {
    this.selectedid = selectedid;
    this.selectedmessage = selectedmessage;
    this.isselected = isSelected;
    this.issendbyMe = issendbyMe;
    this.notifyListeners();
  }
}
