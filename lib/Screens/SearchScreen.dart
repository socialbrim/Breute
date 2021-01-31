import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentpreneur/Screens/SocialMediaProfileScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserInformation> _list = [];

  String query;

  void fetchResults() async {
    if (isContains()) {
      print("contain called--------------------");
      return;
    }
    _list = [];
    final emailSearch = await FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .orderByChild("emial")
        .startAt(query)
        .once();
    final map = emailSearch.value as Map;

    if (map != null) {
      map.forEach((key, value) {
        _list.add(
          UserInformation(
            email: value['emial'] == null ? "" : value['emial'],
            id: key,
            imageUrl: value['imageURL'],
            name: value['userName'],
            phone: value['phone'],
          ),
        );
      });
    }

    final nameSearch = await FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .orderByChild("userName")
        .startAt(query)
        .once();
    final nameSearchdata = nameSearch.value as Map;

    if (nameSearchdata != null) {
      nameSearchdata.forEach((key, value) {
        bool contains = false;
        for (int i = 0; i < _list.length; i++) {
          if (_list[i].id == key) {
            contains = true;
          }
        }
        if (contains) {
          return;
        } else
          _list.add(
            UserInformation(
              email: value['emial'] == null ? "" : value['emial'],
              id: key,
              imageUrl: value['imageURL'],
              name: value['userName'],
              phone: value['phone'],
            ),
          );
      });
    }
    setState(() {});
  }

  bool isContains() {
    bool contains = false;
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].email.contains(query) || _list[i].name.contains(query)) {
        contains = true;
        final filteredList = [..._list];
        _list = [];
        filteredList.forEach((element) {
          if (filteredList[i].email.contains(query) ||
              filteredList[i].name.contains(query)) {
            _list.add(filteredList[i]);
          }
        });
        break;
      }
    }
    return contains;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [Icon(Icons.search)],
          title: TextFormField(
            onChanged: (val) {
              query = val;
              fetchResults();
            },
          ),
        ),
        body: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SocialMediaProfileScreen(
                  isme:
                      _list[index].id == FirebaseAuth.instance.currentUser.uid,
                  uid: _list[index].id,
                ),
              ));
            },
            title: Text("${_list[index].name.toUpperCase()}"),
          ),
        ),
      ),
    );
  }
}
