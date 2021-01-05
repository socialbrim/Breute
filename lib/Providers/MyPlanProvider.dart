import 'package:flutter/material.dart';
import '../models/PlanDetail.dart';

class MyPlanProvider with ChangeNotifier {
  PlanName plan;
  void setPlan(PlanName val) {
    plan = val;
  }
}
