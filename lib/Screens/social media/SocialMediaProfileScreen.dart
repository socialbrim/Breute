import 'dart:io';

import 'package:email_launcher/email_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Providers/socialmedialBarindex.dart';
import 'package:parentpreneur/Screens/editProfile.dart';
import 'package:parentpreneur/models/PostModel.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:parentpreneur/main.dart';
import 'package:share/share.dart';
import './SocialMediaPostScreen.dart';
import 'SearchScreen.dart';
import 'SocialMediaMsgScreen.dart';

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
  int lengthofFollowing = 0;
  int followers = 0;

  void profileFetch() async {
    final followingLength = await FirebaseDatabase.instance
        .reference()
        .child("MyFriends")
        .child(widget.uid)
        .once();
    if (followingLength.value != null) {
      lengthofFollowing = followingLength.value.length;
    }
    if (widget.isme) {
      //..
      final personaldata = await FirebaseDatabase.instance
          .reference()
          .child("User Information")
          .child(widget.uid)
          .once();
      final mapped = personaldata.value as Map;
      print(mapped["bio"]);
      userData = UserInformation(
        email: mapped['emial'] == null ? "" : mapped['emial'],
        id: widget.uid,
        imageUrl: mapped['imageURL'],
        name: mapped['userName'],
        phone: mapped['phone'],
        isVerified: mapped['verified'] == null ? false : mapped['verified'],
        bio: mapped["bio"],
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
              key != "userName" &&
              key != "bio") {
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
        bio: mapped["bio"],
        isVerified: mapped['verified'] == null ? false : mapped['verified'],
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
              key != "userName" &&
              key != "bio") {
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
  void didChangeDependencies() {
    achievedsteps =
        Provider.of<UserProvider>(context, listen: false).achievedsteps;
    achievedWater =
        Provider.of<UserProvider>(context, listen: false).achievedWater;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    profileFetch();
    super.initState();
  }

  File image;

  Future<void> picker() async {
    // ignore: unused_local_variable
    File document;
    var vals;
    // ignore: unused_local_variable
    var _imagesetting = false;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Container(
          height: 120,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Please choose an Verification Document"),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera),
                    label: Text("camera"),
                    onPressed: () async {
                      // ignore: deprecated_member_use
                      vals = await ImagesPicker.openCamera(
                        pickType: PickType.image,
                        cropOpt: CropOption(
                          cropType: CropType.rect,
                        ),
                      );
                      setState(() {
                        _imagesetting = true;
                      });
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("gallery"),
                    onPressed: () async {
                      // ignore: deprecated_member_use
                      vals = await ImagesPicker.pick(
                        cropOpt: CropOption(
                          cropType: CropType.rect,
                        ),
                        count: 1,
                        pickType: PickType.image,
                      );
                      setState(() {
                        _imagesetting = true;
                      });
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {
      if (vals == null) {
        return;
      }
      image = File(vals.first.thumbPath);
    });
  }

  double achievedsteps;
  double achievedWater;

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
                automaticallyImplyLeading: false,
                title: Text(
                  'Profile',
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MdiIcons.facebookMessenger,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SocialMediaMsgScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
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
                              if (userData.isVerified)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    Icon(Icons.check),
                                  ],
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
                                  userData.name == null
                                      ? ""
                                      : '${userData.bio}',
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Edit Profile',
                                          style: theme.text14bold,
                                        ),
                                      ),
                                    )
                                  : _isMyFriend
                                      // ignore: deprecated_member_use
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
                                      // ignore: deprecated_member_use
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
                                height: height * .02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: width,
                                    child: InkWell(
                                      onTap: () {
                                        Share.share(
                                            'check out my profile on Breute App Join now with the app link : xyz');
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            MdiIcons.share,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: width * 0.05,
                                          ),
                                          Text(
                                            "Share",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * .02,
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
                                        '1',
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
                                        '$lengthofFollowing',
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
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height * .04,
                                    ),
                                    FloatingActionButton(
                                      onPressed: () {
                                        Provider.of<BarIndexChange>(context,
                                                listen: false)
                                            .setBarindex(1);
                                      },
                                      child: Icon(MdiIcons.plus),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Text(
                                      "Add new Post !",
                                      style: theme.text14bold,
                                    ),
                                  ],
                                ),
                              )
                            : _list.isEmpty && !widget.isme
                                ? Container(
                                    height: height * .4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                      postModel: _list[
                                                          (_list.length - 1) -
                                                              index],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(
                                                '${_list[(_list.length - 1) - index].postURL}',
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
                  if (widget.isme)
                    Positioned(
                      top: 30,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () async {
                          print(achievedsteps);
                          if (achievedWater <= 8) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:
                                    Text("Award unlocked at 8 glass of water."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              ),
                            );
                            return;
                          }
                          final user =
                              Provider.of<UserProvider>(context, listen: false)
                                  .userInformation;
                          Email email = Email(
                              to: ['test@gmail.com'],
                              subject: 'subject',
                              body:
                                  '$achievedWater glass of water is taken by ${user.name} with user id ${user.id} and want to take a reward');
                          await EmailLauncher.launch(email);
                        },
                        elevation: 15,
                        child: Icon(MdiIcons.water),
                      ),
                    ),
                  if (widget.isme)
                    Positioned(
                      top: 100,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () async {
                          print(achievedsteps);
                          if (achievedsteps <= 10000) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Award unlocked at 10,000 steps."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              ),
                            );
                            return;
                          }
                          final user =
                              Provider.of<UserProvider>(context, listen: false)
                                  .userInformation;
                          Email email = Email(
                              to: ['test@gmail.com'],
                              subject: 'subject',
                              body:
                                  '$achievedsteps steps is done by ${user.name} with user id ${user.id} and want to take a reward');
                          await EmailLauncher.launch(email);
                        },
                        elevation: 15,
                        child: Icon(MdiIcons.trophyAward),
                      ),
                    ),
                  if (widget.isme)
                    Positioned(
                      top: 170,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await picker();
                          if (image != null) {
                            setState(() {
                              isRequesting = true;
                            });
                            final key = FirebaseDatabase.instance
                                .reference()
                                .child("RequestForDoc")
                                .push()
                                .key;
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child("RequestDoc")
                                .child(
                                    "${FirebaseAuth.instance.currentUser.uid}")
                                .child("$key" + ".jpg");
                            await ref.putFile(image);
                            final vals = await ref.getDownloadURL();
                            FirebaseDatabase.instance
                                .reference()
                                .child("RequestForDoc")
                                .child(key)
                                .update({
                              "request ID": "${userData.id}",
                              "dateTime": DateTime.now().toIso8601String(),
                              "imageURL": vals,
                            });

                            FirebaseDatabase.instance
                                .reference()
                                .child("User Information")
                                .child(widget.uid)
                                .update({
                              "Doc Status": "requested",
                            });

                            FirebaseDatabase.instance
                                .reference()
                                .child("RequestForDoc")
                                .child(key)
                                .update({
                              "request ID": "${userData.id}",
                              "dateTime": DateTime.now().toIso8601String()
                            });
                            setState(() {
                              isRequesting = false;
                            });
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: Container(
                                  height: 120,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Verification Request pending"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.camera),
                                            label: Text("Ok"),
                                            onPressed: () async {
                                              Navigator.of(ctx).pop(true);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        elevation: 15,
                        child: isRequesting
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              )
                            : Icon(Icons.verified),
                      ),
                    )
                ],
              ),
            ),
          );
  }

  bool isRequesting = false;
}
