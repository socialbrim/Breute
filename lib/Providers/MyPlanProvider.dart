import 'package:flutter/material.dart';
import '../models/PlanDetail.dart';

class MyPlanProvider with ChangeNotifier {
  PlanName plan;
  Map data;
  void setPlan(PlanName val) {
    plan = val;
  }

  void setData(Map data) {
    this.data = data;
    notifyListeners();
  }
}
