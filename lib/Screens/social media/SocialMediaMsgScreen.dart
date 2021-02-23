import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parentpreneur/Screens/social%20media/SocialMediaChatRoom.dart';
import 'package:parentpreneur/models/UserModel.dart';

import '../../main.dart';

class SocialMediaMsgScreen extends StatefulWidget {
  @override
  _SocialMediaMsgScreenState createState() => _SocialMediaMsgScreenState();
}

class _SocialMediaMsgScreenState extends State<SocialMediaMsgScreen> {
  List<UserInformation> _chatList = [];
  List<UserInformation> _allFriends = [];

  void fetchAllFriends() async {
    //...
    final map = await FirebaseDatabase.instance
        .reference()
        .child("MyFriends")
        .child(FirebaseAuth.instance.currentUser.uid)
        .once();
    final mapped = map.value as Map;
    if (mapped != null) {
      mapped.forEach((key, value) async {
        final eachMap = await FirebaseDatabase.instance
            .reference()
            .child("User Information")
            .child(key)
            .once();
        final eachMapped = eachMap.value as Map;
        if (eachMapped != null) {
          _allFriends.add(
            UserInformation(
              name: eachMapped['userName'],
              imageUrl: eachMapped['imageURL'],
              id: key,
            ),
          );
        }
      });
    }
  }

  void fetchChatList() {
    //...
    FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(FirebaseAuth.instance.currentUser.uid)
        .onValue
        .listen((event) {
      _chatList = [];
      final mapped = event.snapshot.value as Map;
      if (mapped != null) {
        //...
        mapped.forEach((key, value) {
          _chatList.add(
            UserInformation(
              imageUrl: value['imageURL'],
              id: key,
              name: value['name'],
            ),
          );
        });
      }
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    fetchChatList();
    fetchAllFriends();
    super.initState();
  }

  void bottomSheet() {
    _scaffoldKey.currentState.showBottomSheet((context) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          color: theme.colorBackground,
          child: _allFriends.isEmpty
              ? Center(
                  child: Text("Make New Friend Now"),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Text("Chat With?")
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        itemCount: _allFriends.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SocialMediaChat(
                                  uid: _allFriends[index].id,
                                  data: _allFriends[index],
                                ),
                              ),
                            );
                          },
                          title: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .05,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: _allFriends[index].imageUrl ==
                                        null
                                    ? AssetImage('assets/unnamed.png')
                                    : NetworkImage(_allFriends[index].imageUrl),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .05,
                              ),
                              Text(_allFriends[index].name),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          // title: Text(
          //   'Messages',
          // ),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.add,
          //       size: 30,
          //       color: theme.colorPrimary,
          //     ),
          //     onPressed: () {
          //       //...
          //       bottomSheet();
          //     },
          //   ),
          //   SizedBox(
          //     width: width * .03,
          //   ),
          // ],
        ),
        body: _chatList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        bottomSheet();
                      },
                      child: new Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Text(
                      "Start a New Conversation",
                      style: theme.text14bold,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.only(
                        left: 25,
                      ),
                      child: Text(
                        'Conversation',
                        style: theme.text20bold,
                      ),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: theme.colorGrey,
                    //     borderRadius: BorderRadius.circular(
                    //       10,
                    //     ),
                    //   ),
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 15,
                    //     vertical: 2,
                    //   ),
                    //   width: width * .9,
                    //   height: height * .05,
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         MdiIcons.magnify,
                    //       ),
                    //       SizedBox(
                    //         width: width * .06,
                    //       ),
                    //       Text(
                    //         'Search',
                    //         style: theme.text14,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 15,
                      ),
                      height: height * .73,
                      child: ListView.builder(
                        itemCount: _chatList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SocialMediaChat(
                                    uid: _chatList[index].id,
                                    data: _chatList[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.colorPrimary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * .05,
                                        ),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: _chatList[index]
                                                      .imageUrl ==
                                                  null
                                              ? AssetImage('assets/unnamed.png')
                                              : NetworkImage(
                                                  _chatList[index].imageUrl),
                                        ),
                                        SizedBox(
                                          width: width * .05,
                                        ),
                                        Text(
                                          '${_chatList[index].name}',
                                          style: theme.text14bold,
                                        ),
                                      ],
                                    ),
                                    // Divider(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        bottomSheet();
                      },
                      child: new Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
