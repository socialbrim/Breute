import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/models/PostModel.dart';

import '../main.dart';

// ignore: must_be_immutable
class SocialMediaPostScreen extends StatefulWidget {
  PostModel postModel;
  SocialMediaPostScreen({this.postModel});
  @override
  _SocialMediaPostScreenState createState() => _SocialMediaPostScreenState();
}

class _SocialMediaPostScreenState extends State<SocialMediaPostScreen> {
  bool isLiked(Map likeList) {
    // print(likeList);
    if (likeList == null) {
      return false;
    }
    bool _isreturn = false;
    likeList.forEach((key, value) {
      if (key == FirebaseAuth.instance.currentUser.uid) {
        //...
        _isreturn = true;
      }
    });

    return _isreturn;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Post'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                    MdiIcons.delete,
                    size: 28,
                  ),
                  onPressed: () {}),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: height * 0.4,
                width: width,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * .05,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: widget.postModel.imageURl == null
                              ? AssetImage('assets/unnamed.png')
                              : NetworkImage(widget.postModel.imageURl),
                        ),
                        SizedBox(
                          width: width * .05,
                        ),
                        Text(
                          widget.postModel.name == null
                              ? "Unknown"
                              : '${widget.postModel.name}',
                          style: theme.text14bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Divider(
                      height: 0,
                    ),
                    Container(
                      // height: width * .75,
                      width: width,
                      child: Image.network(
                        '${widget.postModel.postURL}',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        LikeButton(
                          onTap: (isLiked) {
                            return onLikeButtonTapped(
                                isLiked, widget.postModel);
                          },
                          isLiked: isLiked(widget.postModel.likeIDs),
                          size: 28,
                          circleColor: CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 28,
                            );
                          },
                          likeCount: widget.postModel.likes == null
                              ? 0
                              : widget.postModel.likes,
                          countBuilder: (int count, bool isLiked, String text) {
                            var color =
                                isLiked ? theme.colorDefaultText : Colors.grey;
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                "0",
                                style: TextStyle(color: color),
                              );
                            } else
                              result = Text(
                                text,
                                style: TextStyle(color: color),
                              );
                            return result;
                          },
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text(
                          'Likes',
                          style: theme.text14,
                        ),
                        SizedBox(
                          width: width * 0.23,
                        ),
                        Icon(
                          Icons.comment,
                          size: 25,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          '19 Comments',
                          style: theme.text14,
                        ),
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
                        '${widget.postModel.caption}',
                        style: theme.text14,
                      ),
                    ),
                    Divider()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, PostModel data) async {
    print(isLiked);
    print("------------------");
    final likes = data.likes == null ? 0 : data.likes;
    if (!isLiked) {
      FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(data.uid)
          .child(data.postID)
          .child("likeIDs")
          .update({
        FirebaseAuth.instance.currentUser.uid: 1,
      });

      FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(data.uid)
          .child(data.postID)
          .update({
        "likes": likes + 1,
      });

      print(isLiked);
    } else {
      FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(data.uid)
          .child(data.postID)
          .child("likeIDs")
          .child(FirebaseAuth.instance.currentUser.uid)
          .remove();
      FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(data.uid)
          .child(data.postID)
          .update({
        "likes": likes - 1,
      });
    }

    return !isLiked;
  }
}
