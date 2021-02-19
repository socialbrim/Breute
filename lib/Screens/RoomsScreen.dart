import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';
import '../models/UserModel.dart';
import '../Providers/User.dart';
import 'package:provider/provider.dart';
import './RoomChat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/RoomModel.dart';

class RoomsScreen extends StatefulWidget {
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  int index = 0;
  int choosenPlan = 0;
  bool ispublished = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TimeOfDay _scheduleTime;
  TextEditingController _name = TextEditingController();
  TextEditingController _pass = TextEditingController();
  List<RoomModel> _trendingList = [];
  List<RoomModel> _scheduleMyList = [];
  List<RoomModel> _myRoomList = [];
  bool _isLoading = true;

  Future<void> fetchScheduledRooms() async {
    try {
      //..
      final data = await FirebaseDatabase.instance
          .reference()
          .child("Roomsinformation")
          .orderByChild("isSchedule")
          .equalTo(true)
          .once();
      if (data.value != null) {
        final dataset = data.value as Map;
        dataset.forEach((key, value) {
          _scheduleMyList.add(
            RoomModel(
              dateTime: value['roomName'] == null
                  ? DateTime.now()
                  : DateTime.parse(
                      value['dateTime'],
                    ),
              id: key,
              name: value['roomName'],
              roomIDTOENTER: value['roomIDtoEnter'],
              forSchedulesAndAll: value,
              scheduleTime: value['scheduleTime'],
            ),
          );
        });
      }

      _scheduleMyList.removeWhere((element) {
        bool isRemove = true;
        element.forSchedulesAndAll.forEach((key, value) {
          if (key == FirebaseAuth.instance.currentUser.uid) {
            isRemove = false;
          }
        });
        return isRemove;
      });
      print(_scheduleMyList.length);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wront to fetch Schedule List");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMyRooms() async {
    try {
      //..
      final data = await FirebaseDatabase.instance
          .reference()
          .child("Roomsinformation")
          .once();
      if (data.value != null) {
        final dataset = data.value as Map;
        dataset.forEach((key, value) {
          _myRoomList.add(
            RoomModel(
              dateTime: value['roomName'] == null
                  ? DateTime.now()
                  : DateTime.parse(
                      value['dateTime'],
                    ),
              id: key,
              name: value['roomName'],
              roomIDTOENTER: value['roomIDtoEnter'],
              forSchedulesAndAll: value,
              scheduleTime: value['scheduleTime'],
            ),
          );
        });
      }

      _myRoomList.removeWhere((element) {
        bool isRemove = true;
        element.forSchedulesAndAll.forEach((key, value) {
          if (key == FirebaseAuth.instance.currentUser.uid) {
            isRemove = false;
          }
        });
        return isRemove;
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wront to fetch Schedule List");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchTrendingOpenRooms() async {
    try {
      final data = await FirebaseDatabase.instance
          .reference()
          .child("Roomsinformation")
          .orderByChild('isPublic')
          .equalTo(true)
          .once();
      final dataset = data.value as Map;
      if (dataset != null) {
        dataset.forEach((key, value) {
          _trendingList.add(
            RoomModel(
              dateTime: value['roomName'] == null
                  ? DateTime.now()
                  : DateTime.parse(
                      value['dateTime'],
                    ),
              id: key,
              name: value['roomName'],
              roomIDTOENTER: value['roomIDtoEnter'],
            ),
          );
        });
      }
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wront to fetch trendng list");
      setState(() {});
    }
  }

  void bottomSheet() {
    _scaffoldKey.currentState.showBottomSheet(
      (context) => StatefulBuilder(
        builder: (ctx, setState) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            height: height * .47,
            width: width,
            color: theme.colorBackgroundDialog,
            child: Column(
              children: [
                Text(
                  '+ Create Room',
                  style: theme.text16boldPrimary,
                ),
                SizedBox(
                  height: height * .01,
                ),
                Container(
                  width: width * .9,
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: 'Name of room',
                      focusColor: theme.colorPrimary,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .01,
                ),
                Row(
                  children: [
                    Container(
                      width: width * .4,
                      child: RadioListTile(
                          title: Text(
                            "Public",
                            style: theme.text16,
                          ),
                          activeColor: theme.colorPrimary,
                          value: 0,
                          groupValue: choosenPlan,
                          onChanged: (val) {
                            setState(() {
                              choosenPlan = val;
                            });
                          }),
                    ),
                    Container(
                      width: width * .4,
                      child: RadioListTile(
                          title: Text(
                            "Private",
                            style: theme.text16,
                          ),
                          activeColor: theme.colorPrimary,
                          value: 1,
                          groupValue: choosenPlan,
                          onChanged: (val) {
                            setState(() {
                              choosenPlan = val;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .003,
                ),
                choosenPlan == 1
                    ? Container(
                        width: width * .9,
                        child: TextFormField(
                          controller: _pass,
                          decoration: InputDecoration(
                            hintText: 'Create Password',
                            focusColor: theme.colorPrimary,
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: height * .01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * .04,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: Checkbox(
                        value: ispublished,
                        activeColor: theme.colorPrimary,
                        onChanged: (val) {
                          setState(() {
                            ispublished = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Schedule ',
                      style: GoogleFonts.workSans(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: width * .02,
                    ),
                    ispublished == true
                        ? GestureDetector(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: 12, minute: 00),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child,
                                  );
                                },
                              );

                              setState(() {
                                if (time != null) {
                                  _scheduleTime = time;
                                }
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.04,
                                width: width * 0.3,
                                color: theme.colorPrimary,
                                child: Text(
                                  _scheduleTime == null
                                      ? 'Set Time'
                                      : pmOrAm(
                                          "${_scheduleTime.hour} : ${_scheduleTime.minute}"),
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.text14boldWhite,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: height * .01,
                ),
                SizedBox(
                  height: height * .015,
                ),
                InkWell(
                  onTap: () {
                    UserInformation userInfo;
                    userInfo = Provider.of<UserProvider>(context, listen: false)
                        .userInformation;
                    final key = FirebaseDatabase.instance
                        .reference()
                        .child("GroupChatRoom")
                        .push()
                        .key;
                    final ref = FirebaseDatabase.instance
                        .reference()
                        .child("GroupChatRoom")
                        .child("$key");
                    final newkey = ref.push().key;
                    ref.child(newkey).update({
                      'message': "Welcome everyone",
                      "uid": userInfo.id,
                      "timeStamp": DateTime.now().toIso8601String(),
                      'Name': userInfo.name,
                      "DpURL": userInfo.imageUrl,
                    });
                    if (choosenPlan == 0) {
                      FirebaseDatabase.instance
                          .reference()
                          .child("Roomsinformation")
                          .child(key)
                          .update({
                        "roomID": key,
                        "dateTime": DateTime.now().toIso8601String(),
                        "roomName": _name.text,
                        "isPublic": true,
                        "isSchedule": ispublished,
                        "roomIDtoEnter": key.substring(1, 6),
                        "scheduleTime": ispublished
                            ? "${_scheduleTime.hour} : ${_scheduleTime.minute}"
                            : null,
                        "${FirebaseAuth.instance.currentUser.uid}": "Admin",
                      });
                    }
                    FirebaseDatabase.instance
                        .reference()
                        .child("Roomsinformation")
                        .child(key)
                        .update({
                      "roomID": key,
                      "dateTime": DateTime.now().toIso8601String(),
                      "roomName": _name.text,
                      "isPublic": choosenPlan == 0 ? true : false,
                      "password": _pass.text,
                      "isSchedule": ispublished,
                      "roomIDtoEnter": key.substring(1, 6),
                      "scheduleTime": ispublished
                          ? "${_scheduleTime.hour} : ${_scheduleTime.minute}"
                          : null,
                      "${FirebaseAuth.instance.currentUser.uid}": "Admin",
                    });
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatRoomGrp(
                          chatRoomID: key,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                    color: theme.colorCompanion,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 81,
                      ),
                      child: Text(
                        ' Submit',
                        style: theme.text16boldWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    fetchTrendingOpenRooms()
        .then((value) => fetchMyRooms().then((value) => fetchScheduledRooms()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text("Rooms"),
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
                      height: height * .025,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              bottomSheet();
                            },
                            child: Card(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                              ),
                              color: theme.colorPrimary,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      MdiIcons.accountPlus,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      ' Create',
                                      style: theme.text16boldWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          InkWell(
                            onTap: () {
                              bottomSheettoJoin();
                            },
                            child: Card(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                              ),
                              color: theme.colorPrimary,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 23,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      MdiIcons.plus,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Join',
                                      style: theme.text16boldWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    // Card(
                    //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //   elevation: 10,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(35),
                    //   ),
                    //   child: Container(
                    //     height: 50,
                    //     width: width,
                    //     child: Row(
                    //       children: [
                    //         SizedBox(
                    //           width: width * .04,
                    //         ),
                    //         Icon(
                    //           MdiIcons.magnify,
                    //           size: 23,
                    //         ),
                    //         SizedBox(
                    //           width: width * .025,
                    //         ),
                    //         Container(
                    //           height: 50,
                    //           width: width * .5,
                    //           child: TextFormField(
                    //             cursorColor: theme.colorPrimary,
                    //             decoration: InputDecoration(
                    //               hintText: "Search Rooms",
                    //               hintStyle: theme.text16,
                    //               border: InputBorder.none,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: height * 0.04,
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * .06,
                        ),
                        Text(
                          'Scheduled Rooms',
                          style: theme.text20bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Card(
                      elevation: 20,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: _scheduleMyList.length * height * .1,
                        width: width * .9,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _scheduleMyList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomGrp(
                                      chatRoomID: _scheduleMyList[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Room Name:   ",
                                            style: theme.text14bold,
                                          ),
                                          Text(
                                            "${_scheduleMyList[index].name}",
                                            style: theme.text14,
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "Room Id:   ",
                                      //       style: theme.text14bold,
                                      //     ),
                                      //     Text(
                                      //       "${_scheduleMyList[index].id}",
                                      //       style: theme.text14,
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            "Time:   ",
                                            style: theme.text14bold,
                                          ),
                                          Text(
                                            pmOrAm(
                                                "${_scheduleMyList[index].scheduleTime}"),
                                            style: theme.text14,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * .06,
                        ),
                        Text(
                          'Trending Rooms',
                          style: theme.text20bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Card(
                      elevation: 20,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: _trendingList.length * height * .07,
                        width: width * .9,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _trendingList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Room Name:   ",
                                          style: theme.text14bold,
                                        ),
                                        Text(
                                          "${_trendingList[index].name}",
                                          style: theme.text14,
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Room Id:   ",
                                    //       style: theme.text14bold,
                                    //     ),
                                    //     Text(
                                    //       "${_trendingList[index].id}",
                                    //       style: theme.text14,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * .06,
                        ),
                        Text(
                          'My Rooms',
                          style: theme.text20bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Card(
                      elevation: 20,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: _myRoomList.length * height * .07,
                        width: width * .9,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _myRoomList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Room Name:   ",
                                          style: theme.text14bold,
                                        ),
                                        Text(
                                          "${_myRoomList[index].name}",
                                          style: theme.text14,
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Room Id:   ",
                                    //       style: theme.text14bold,
                                    //     ),
                                    //     Text(
                                    //       "${_myRoomList[index].id}",
                                    //       style: theme.text14,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .1,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  TextEditingController _id = TextEditingController();
  TextEditingController _passtoenter = TextEditingController();

  Map ifprivate;
  bool _isPrivate = false;
  void bottomSheettoJoin() {
    _scaffoldKey.currentState.showBottomSheet((context) => StatefulBuilder(
          builder: (ctx, setState) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              height: height * .47,
              width: width,
              color: theme.colorBackgroundDialog,
              child: Column(
                children: [
                  Text(
                    'Join Room',
                    style: theme.text16boldPrimary,
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    width: width * .9,
                    child: TextFormField(
                      controller: _id,
                      decoration: InputDecoration(
                        hintText: 'ID of room',
                        focusColor: theme.colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .003,
                  ),
                  choosenPlan == 1
                      ? Container(
                          width: width * .9,
                          child: TextFormField(
                            controller: _passtoenter,
                            decoration: InputDecoration(
                              hintText: 'Create Password',
                              focusColor: theme.colorPrimary,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: height * .015,
                  ),
                  InkWell(
                    onTap: () async {
                      final data = await FirebaseDatabase.instance
                          .reference()
                          .child("Roomsinformation")
                          .orderByChild("roomIDtoEnter")
                          .equalTo(_id.text)
                          .once();
                      final dat = data.value as Map;
                      if (dat != null) {
                        dat.forEach((key, value) {
                          if (value['isPublic']) {
                            Navigator.of(ctx).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatRoomGrp(
                                  chatRoomID: key,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              choosenPlan = 1;
                              _isPrivate = true;
                              ifprivate = dat;
                            });
                          }
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Room not found");
                      }
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                      color: theme.colorCompanion,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 81,
                        ),
                        child: Text(
                          _isPrivate ? "Change Code" : ' Submit',
                          style: theme.text16boldWhite,
                        ),
                      ),
                    ),
                  ),
                  if (_isPrivate)
                    InkWell(
                      onTap: () async {
                        //....
                        bool isNew = true;
                        ifprivate.forEach((key, value) {
                          final vl = value as Map;
                          vl.forEach((key, value) {
                            if (key == FirebaseAuth.instance.currentUser.uid) {
                              isNew = false;
                            }
                          });
                        });
                        ifprivate.forEach((key, value) {
                          if (value['password'] == _passtoenter.text) {
                            //....
                            if (isNew) {
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("Roomsinformation")
                                  .child(key)
                                  .update({
                                "${FirebaseAuth.instance.currentUser.uid}":
                                    "User",
                              });
                            }
                            Navigator.of(ctx).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatRoomGrp(
                                  chatRoomID: key,
                                ),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Enter Correct password");
                          }
                        });

                        //....
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        color: theme.colorCompanion,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 81,
                          ),
                          child: Text(
                            ' Submit',
                            style: theme.text16boldWhite,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ));
  }

  String pmOrAm(String time) {
    if (time == null) {
      return "";
    }
    final data = time.split(":");
    var val = int.parse(data[0]);
    var min = int.parse(data[1]);
    var pmORAm = "AM";
    if (val > 12) {
      val = val - 12;
      pmORAm = "PM";
    } else if (val == 0) {
      val = val + 12;
    } else if (val == 12) {
      pmORAm = "PM";
    }
    String zero;
    String aZero;
    val < 12
        ? val > 9
            ? zero = ""
            : zero = ""
        : zero = "";
    min < 10 ? aZero = "0" : aZero = "";
    return "$zero$val:$aZero${data[1]} $pmORAm";
  }
}
