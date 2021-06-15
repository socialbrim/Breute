import 'package:flutter/material.dart';
import 'package:parentpreneur/models/UserModel.dart';

class UserProvider with ChangeNotifier {
  UserInformation userInformation;
  double achievedsteps;
  double achievedWater;
  double achievedCalories;

  void setUser(UserInformation userInformation) {
    this.userInformation = userInformation;
    notifyListeners();
  }
}
