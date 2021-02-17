import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class RoomInformation extends StatefulWidget {
  String roomID;
  RoomInformation({this.roomID});
  @override
  _RoomInformationState createState() => _RoomInformationState();
}

class _RoomInformationState extends State<RoomInformation> {
  List<UserInformation> _users = [];
  String id;
  String pass;
  String grpName;
  String adminID;
  String grpDP; //.... mood hua to badme krenge
  bool currentUserTypeAdmin = false;

  ///... mood hua to
  void roomInformation() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("Roomsinformation")
        .child(widget.roomID)
        .once();
    final map = data.value as Map;
    for (MapEntry entry in map.entries) {
      print("${entry.key} ${entry.value}");
      if (entry.value == "User") {
        final mapped = await FirebaseDatabase.instance
            .reference()
            .child("User Information")
            .child(entry.key)
            .once();

        UserInformation userData = new UserInformation(
          email: mapped.value['emial'],
          id: mapped.value['uid'],
          imageUrl: mapped.value['imageURL'],
          name: mapped.value['userName'],
          phone: mapped.value['phone'],
          isPhone: mapped.value['isPhone'],
        );
        _users.add(userData);
        print("done------");
      } else if (entry.value == "Admin") {
        final mapped = await FirebaseDatabase.instance
            .reference()
            .child("User Information")
            .child(entry.key)
            .once();
        currentUserTypeAdmin =
            mapped.value['uid'] == FirebaseAuth.instance.currentUser.uid;
        adminID = mapped.value['uid'];
        UserInformation userData = new UserInformation(
          email: mapped.value['emial'],
          id: mapped.value['uid'],
          imageUrl: mapped.value['imageURL'],
          name: mapped.value['userName'],
          phone: mapped.value['phone'],
          isPhone: mapped.value['isPhone'],
        );
        _users.add(userData);
        print("done");
      } else {
        //.....
        id = map['roomIDtoEnter'];
        grpName = map['roomName'];
        pass = map['password'];
      }
      print(_users.length);
    }
    setState(() {});
  }

  @override
  void initState() {
    roomInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$grpName"),
      ),
    );
  }
}
