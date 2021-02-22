import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/socialmedialBarindex.dart';
import 'package:parentpreneur/Screens/editProfile.dart';
import 'package:parentpreneur/models/PostModel.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:provider/provider.dart';

import 'package:parentpreneur/main.dart';
import './SocialMediaPostScreen.dart';

class SocialMediaProfileScreen extends StatefulWidget {
  @required
  final String uid;
  @required
  final bool isme;
  SocialMediaProfileScreen({
    this.uid,
    this.isme,
  });
  @override
  _SocialMediaProfileScreenState createState() =>
      _SocialMediaProfileScreenState();
}

class _SocialMediaProfileScreenState extends State<SocialMediaProfileScreen> {
  bool _isMyFriend = false;
  UserInformation userData;
  List<PostModel> _list = [];
  bool _isLoading = true;
  // int lengthofFollowing = 0;

  void profileFetch() async {
    if (widget.isme) {
      //..
      final personaldata = await FirebaseDatabase.instance
          .reference()
          .child("User Information")
          .child(widget.uid)
          .once();
      final mapped = personaldata.value as Map;

      userData = UserInformation(
        email: mapped['emial'] == null ? "" : mapped['emial'],
        id: widget.uid,
        imageUrl: mapped['imageURL'],
        name: mapped['userName'],
        phone: mapped['phone'],
      );
      final socailMediaLife = await FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(widget.uid)
          .once();

      if (socailMediaLife.value != null) {
        socailMediaLife.value.forEach((key, value) {
          if (key != "emial" &&
              key != "imageURL" &&
              key != "phone" &&
              key != "userName") {
            _list.add(
              PostModel(
                caption: value['caption'],
                comments: value['comments'],
                imageURl: socailMediaLife.value['imageURL'],
                likes: value['likes'],
                name: socailMediaLife.value['userName'],
                postID: key,
                postURL: value['image'],
                uid: widget.uid,
                likeIDs: value['likeIDs'],
                dateTime: value['dateTime'] == null
                    ? DateTime.now()
                    : DateTime.parse(
                        value['dateTime'],
                      ),
              ),
            );
          }
        });
      }
      setState(() {
        print(_list.length);
        _isLoading = false;
      });
    } else {
      final personaldata = await FirebaseDatabase.instance
          .reference()
          .child("User Information")
          .child(widget.uid)
          .once();
      final mapped = personaldata.value as Map;

      userData = UserInformation(
        email: mapped['emial'] == null ? "" : mapped['emial'],
        id: widget.uid,
        imageUrl: mapped['imageURL'],
        name: mapped['userName'],
        phone: mapped['phone'],
      );

      final isFriend = await FirebaseDatabase.instance
          .reference()
          .child("MyFriends")
          .child(FirebaseAuth.instance.currentUser.uid)
          .orderByKey()
          .equalTo(widget.uid)
          .once();
      if (isFriend.value != null) {
        _isMyFriend = true;
      }

      // ignore: unused_local_variable
      final socailMediaLife = await FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(widget.uid)
          .once();
      if (socailMediaLife.value != null) {
        socailMediaLife.value.forEach((key, value) {
          if (key != "emial" &&
              key != "imageURL" &&
              key != "phone" &&
              key != "userName") {
            _list.add(
              PostModel(
                caption: value['caption'],
                comments: value['comments'],
                imageURl: socailMediaLife.value['imageURL'],
                likes: value['likes'],
                name: socailMediaLife.value['userName'],
                postID: key,
                postURL: value['image'],
                uid: widget.uid,
                likeIDs: value['likeIDs'],
                dateTime: value['dateTime'] == null
                    ? DateTime.now()
                    : DateTime.parse(
                        value['dateTime'],
                      ),
              ),
            );
          }
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    profileFetch();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: theme.colorBackground,
              appBar: AppBar(
                title: Text(userData.name.toUpperCase()),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(0),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: userData.imageUrl == null
                                  ? AssetImage('assets/unnamed.png')
                                  : NetworkImage(userData.imageUrl),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Center(
                            child: Text(
                              userData.name == null
                                  ? "Unknown"
                                  : '${userData.name.toUpperCase()}',
                              style: theme.text20boldPrimary,
                            ),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Container(
                            width: width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Text(
                              'Here, Bio will be displayed.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          widget.isme
                              ? InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: width * .6,
                                    height: height * .04,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.colorGrey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Edit Profile',
                                      style: theme.text14bold,
                                    ),
                                  ),
                                )
                              : _isMyFriend
                                  ? RaisedButton(
                                      color: theme.colorCompanion,
                                      onPressed: () {
                                        final snackBar = SnackBar(
                                          content: Text(
                                              'You removed ${userData.name.toUpperCase()}'),
                                          duration: Duration(seconds: 2),
                                        );
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child("MyFriends")
                                            .child(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .child(widget.uid)
                                            .remove();
                                        _scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          _isMyFriend = false;
                                        });
                                      },
                                      child: Text(
                                        "Unfollow",
                                        style: theme.text14boldWhite,
                                      ),
                                    )
                                  : RaisedButton(
                                      color: theme.colorPrimary,
                                      onPressed: () {
                                        final snackBar = SnackBar(
                                          content: Text(
                                              'You started following ${userData.name.toUpperCase()}'),
                                          duration: Duration(seconds: 2),
                                        );
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child("MyFriends")
                                            .child(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .update({
                                          widget.uid: "true",
                                        });

                                        _scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          _isMyFriend = true;
                                        });
                                      },
                                      child: Text(
                                        "Follow",
                                        style: theme.text14boldWhite,
                                      ),
                                    ),
                          SizedBox(
                            height: height * .05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Photos',
                                    style: theme.text16,
                                  ),
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Text(
                                    _list != null ? '${_list.length}' : "0",
                                    style: theme.text18bold,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width * .05,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Followers',
                                    style: theme.text16,
                                  ),
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Text(
                                    '350',
                                    style: theme.text18bold,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width * .05,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Follows',
                                    style: theme.text16,
                                  ),
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Text(
                                    '29',
                                    style: theme.text18bold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .06,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    Divider(
                      height: 0,
                      color: theme.colorDefaultText,
                    ),
                    _list.isEmpty && widget.isme
                        ? Center(
                            child: InkWell(
                                onTap: () {
                                  Provider.of<BarIndexChange>(context,
                                          listen: false)
                                      .setBarindex(1);
                                },
                                child: Text(
                                    "Create Post Now!\nClick here to create!")),
                          )
                        : _list.isEmpty && !widget.isme
                            ? Container(
                                height: height * .4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      MdiIcons.cameraImage,
                                      size: 60,
                                      color: theme.colorDefaultText,
                                    ),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    Text(
                                      "No Posts Yet!",
                                      style: theme.text16,
                                    ),
                                    SizedBox(
                                      height: height * .03,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: height * .5,
                                width: width,
                                child: GridView.builder(
                                  cacheExtent: 9999,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: _list.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onLongPress: () {},
                                      child: Container(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SocialMediaPostScreen(
                                                  postModel: _list[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.network(
                                            '${_list[index].postURL}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    SizedBox(
                      height: height * 1,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
