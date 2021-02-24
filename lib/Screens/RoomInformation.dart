import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

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
  bool _isLoading = true;

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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    roomInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("$grpName"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Room Id:   ",
                          style: theme.text16bold,
                        ),
                        Text(
                          id,
                          style: theme.text16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  if (pass != "")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Password:   ",
                            style: theme.text16bold,
                          ),
                          Text(
                            pass,
                            style: theme.text16,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "${_users.length}  " + "Participants",
                    style: theme.text16bold,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Card(
                    elevation: 20,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: _users.length * height * .16,
                      width: width * .9,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                      backgroundImage:
                                          _users[index].imageUrl == null
                                              ? AssetImage("assets/unnamed.png")
                                              : NetworkImage(
                                                  _users[index].imageUrl),
                                      radius: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Name:   ",
                                            style: theme.text12bold,
                                          ),
                                          Text(
                                            "${_users[index].name}",
                                            style: theme.text12grey,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Email:   ",
                                            style: theme.text12bold,
                                          ),
                                          Container(
                                            width: width * 0.4,
                                            child: Text(
                                              "${_users[index].email}",
                                              softWrap: true,
                                              style: theme.text12grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Phone:   ",
                                            style: theme.text12bold,
                                          ),
                                          Text(
                                            "${_users[index].phone}",
                                            style: theme.text12grey,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      if (adminID == _users[index].id)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.green,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "Admin",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.logout,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Text(
                            "Leave Room",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
