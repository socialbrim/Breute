import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentpreneur/Screens/social media/SocialMediaProfileScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';

import '../../main.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserInformation> _list = [];
  List<UserInformation> _filterList = [];

  String query;
  TextEditingController _ctrl = new TextEditingController();

  void fetchResults() async {
    final emailSearch = await FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .once();
    final map = emailSearch.value as Map;

    if (map != null) {
      map.forEach((key, value) {
        if (value['userName'] != null && value['emial'] != null) {
          _list.add(
            UserInformation(
              email: value['emial'] == null ? "" : value['emial'],
              id: key,
              imageUrl: value['imageURL'],
              name: value['userName'],
              phone: value['phone'],
            ),
          );
        }
      });
    }

    setState(() {
      if (_list != null) {
        _filterList = _list;
      }
    });
  }

  void isContains() {
    //....
    _filterList = [];
    _list.forEach((element) {
      if (element.name.toLowerCase().contains(
            _ctrl.text.toLowerCase(),
          )) {
        _filterList.add(element);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    fetchResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(Icons.search),
            ),
          ],
          title: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
            controller: _ctrl,
            onChanged: (val) {
              isContains();
            },
          ),
        ),
        body: ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SocialMediaProfileScreen(
                    isme: _filterList[index].id ==
                        FirebaseAuth.instance.currentUser.uid,
                    uid: _filterList[index].id,
                  ),
                ));
              },
              title: Row(
                children: [
                  SizedBox(
                    width: width * .05,
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: _filterList[index].imageUrl == null
                        ? AssetImage('assets/unnamed.png')
                        : NetworkImage(_filterList[index].imageUrl),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Text(
                    "${_filterList[index].name.toUpperCase()}",
                    style: theme.text14bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
