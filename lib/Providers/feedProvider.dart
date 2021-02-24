import 'package:flutter/material.dart';
import '../models/PostModel.dart';

class FeedProvider with ChangeNotifier {
  List<PostModel> _list = [];
  PostModel commentHome;
  set setList(List data) {
    _list = [];
    _list = data;

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

  PostModel getFiltered(String id, bool isPostHome) {
    if (isPostHome) {
      return commentHome;
    }
    int index = _list.indexWhere((element) => element.postID == id);
    return _list[index];
  }
}
