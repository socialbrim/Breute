import 'package:flutter/cupertino.dart';
import 'package:parentpreneur/models/workoutModel.dart';

class FavProvider with ChangeNotifier {
  Map<String, WorkoutModel> map = {};

  void addFav(WorkoutModel model) {
    map.putIfAbsent(model.id, () => model);
    notifyListeners();
  }

  void notifiers() {
    print(map);
  }

  void removeFav(WorkoutModel model) {
    map.remove(model.id);

    notifyListeners();
  }
}
