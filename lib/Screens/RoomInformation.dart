import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentpreneur/models/UserModel.dart';

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
  String grpDP;

  ///... mood hua to
  void roomInformation() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("Roomsinformation")
        .child(widget.roomID)
        .once();
    final map = data.value as Map;
    for (MapEntry entry in map.entries) {
      if (entry.key == "User") {
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
      } else if (entry.key == "Admin") {
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
      } else {
        //.....
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
