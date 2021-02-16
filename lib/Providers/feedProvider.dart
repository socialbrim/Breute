import 'package:flutter/material.dart';
import '../models/PostModel.dart';

class FeedProvider with ChangeNotifier {
  List<PostModel> _list = [];

  set setList(List data) {
    _list = [];
    _list = data;
    print(_list.length);
    notifyListeners();
  }

  get getData {
    return [..._list];
  }

  void setChangeInFeed(String id, PostModel data) {
    final index = _list.indexWhere((element) => element.postID == id);
    _list[index] = data;
    notifyListeners();
  }

  PostModel getFiltered(String id) {
    int index = _list.indexWhere((element) => element.postID == id);
    return _list[index];
  }
}
