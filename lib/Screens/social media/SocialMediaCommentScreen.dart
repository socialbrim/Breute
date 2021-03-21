import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parentpreneur/Providers/feedProvider.dart';
import 'package:provider/provider.dart';
import '../../models/PostModel.dart';
import '../../main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Providers/User.dart';

// ignore: must_be_immutable
class SocialMediaCommentScreen extends StatefulWidget {
  PostModel post;
  bool isCommentHome;
  SocialMediaCommentScreen({
    this.post,
    this.isCommentHome,
  });
  @override
  _SocialMediaCommentScreenState createState() =>
      _SocialMediaCommentScreenState();
}

class _SocialMediaCommentScreenState extends State<SocialMediaCommentScreen> {
  TextEditingController comment = new TextEditingController();
  PostModel data;
  bool isReply = false;
  String replyID;
  String replyName;
  var focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    data = Provider.of<FeedProvider>(context)
        .getFiltered(widget.post.postID, widget.isCommentHome);
    super.didChangeDependencies();
  }

  List<Widget> parseData() {
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<Widget> _list = [];

    if (data.comments != null) {
      data.comments.forEach((key, value) {
        _list.add(Container(
          // height: height * ,
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: width * .05,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: value['imageURL'] == null
                        ? AssetImage('assets/unnamed.png')
                        : NetworkImage(value['imageURL']),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value['name'] == null ? 'Unknown' : value['name'],
                        style: theme.text14bold,
                      ),
                      Container(
                        width: width * .7,
                        child: Text(
                          value['comment'],
                          style: theme.text14,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isReply = true;
                    replyID = key;
                    replyName =
                        value['name'] == null ? 'Unknown' : value['name'];
                    comment.text = "@$replyName";
                    FocusScope.of(context).requestFocus(focusNode);
                  });
                },
                child: Text("reply"),
              ),
              Container(
                height: value['reply'] == null
                    ? 10
                    : (value['reply'] as Map).length * 60.0,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView(
                        children: reply(value['reply']) == null
                            ? []
                            : reply(value['reply']),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ));
      });
    }
    return _list;
  }

  List<Widget> reply(Map data) {
    List<Widget> _list = [];
    if (data == null) {
      return null;
    }
    print(data.length);
    data.forEach((key, value) {
      _list.add(
        Container(
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value['name'] == null ? "Unknown" : value['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                value['comment'] == null ? "" : value['comment'],
                softWrap: true,
              ),
            ],
          ),
        ),
      );
    });
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        title: Text('All Comments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .025,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * .05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: widget.post.imageURl == null
                          ? AssetImage('assets/unnamed.png')
                          : NetworkImage(widget.post.imageURl),
                    ),
                  ],
                ),
                SizedBox(
                  width: width * .05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.name == null
                          ? "Unknown"
                          : '${widget.post.name.toUpperCase()}',
                      style: theme.text16bold,
                    ),
                    Container(
                      width: width * .7,
                      child: Text(
                        '${widget.post.caption}',
                        style: theme.text14,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: height * .02,
            ),
            Text(
              'Comments',
              style: theme.text18boldPrimary,
            ),
            SizedBox(
              height: height * .02,
            ),
            Container(
                height: height * .61,
                child: ListView(
                  cacheExtent: 999,
                  children: parseData(),
                )),
            Container(
              width: width,
              padding: EdgeInsets.only(top: 5, bottom: 15, left: 13, right: 13),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorDefaultText,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    suffix: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        if (isReply) {
                          setState(() {
                            isReply = false;
                          });
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                        setState(() {
                          comment.clear();
                        });
                      },
                    ),
                    prefix: IconButton(
                      onPressed: () {
                        if (isReply) {
                          final user =
                              Provider.of<UserProvider>(context, listen: false)
                                  .userInformation;

                          Map data = {};
                          if (widget.post.comments != null) {
                            data = widget.post.comments;
                          }

                          data[replyID].putIfAbsent("reply", () => {});
                          if (data[replyID]["reply"].containsKey(
                              FirebaseAuth.instance.currentUser.uid)) {
                            data[replyID]["reply"]
                                .remove(FirebaseAuth.instance.currentUser.uid);
                          }
                          data[replyID]["reply"]
                              .putIfAbsent("${user.id}", () => {});
                          data[replyID]["reply"]['${user.id}']
                              .putIfAbsent("comment", () => comment.text);
                          data[replyID]["reply"]['${user.id}']
                              .putIfAbsent("imageURL", () => user.imageUrl);
                          data[replyID]["reply"]['${user.id}']
                              .putIfAbsent("name", () => user.name);
                          print(data);
                          PostModel change = PostModel(
                              caption: widget.post.caption,
                              comments: data,
                              dateTime: widget.post.dateTime,
                              imageURl: widget.post.imageURl,
                              likeIDs: widget.post.likeIDs,
                              likes: widget.post.likes,
                              name: widget.post.name,
                              postID: widget.post.postID,
                              postURL: widget.post.postURL,
                              uid: widget.post.uid);
                          if (widget.isCommentHome) {
                            Provider.of<FeedProvider>(context, listen: false)
                                .commentHome = change;
                          } else {
                            Provider.of<FeedProvider>(context, listen: false)
                                .setChangeInFeed(widget.post.postID, change);
                          }

                          FirebaseDatabase.instance
                              .reference()
                              .child("Social Media Data")
                              .child(widget.post.uid)
                              .child(widget.post.postID)
                              .child("comments")
                              .child(replyID)
                              .child("reply")
                              .update({
                            FirebaseAuth.instance.currentUser.uid: {
                              "comment": comment.text,
                              "imageURL": user.imageUrl,
                              "name": user.name,
                            }
                          });
                          FocusScope.of(context).unfocus();
                          comment.clear();
                          return;
                        }

                        try {
                          final user =
                              Provider.of<UserProvider>(context, listen: false)
                                  .userInformation;
                          Map data = {};
                          if (widget.post.comments != null) {
                            data = widget.post.comments;
                          }

                          if (data.containsKey(
                              FirebaseAuth.instance.currentUser.uid)) {
                            data.remove(FirebaseAuth.instance.currentUser.uid);
                          }
                          data.putIfAbsent(
                              FirebaseAuth.instance.currentUser.uid, () => {});
                          data[FirebaseAuth.instance.currentUser.uid]
                              .putIfAbsent("comment", () => comment.text);
                          data[FirebaseAuth.instance.currentUser.uid]
                              .putIfAbsent("imageURL", () => user.imageUrl);
                          data[FirebaseAuth.instance.currentUser.uid]
                              .putIfAbsent("name", () => user.name);
                          print(data);
                          PostModel change = PostModel(
                              caption: widget.post.caption,
                              comments: data,
                              dateTime: widget.post.dateTime,
                              imageURl: widget.post.imageURl,
                              likeIDs: widget.post.likeIDs,
                              likes: widget.post.likes,
                              name: widget.post.name,
                              postID: widget.post.postID,
                              postURL: widget.post.postURL,
                              uid: widget.post.uid);
                          if (widget.isCommentHome) {
                            Provider.of<FeedProvider>(context, listen: false)
                                .commentHome = change;
                          } else {
                            Provider.of<FeedProvider>(context, listen: false)
                                .setChangeInFeed(widget.post.postID, change);
                          }
                          FirebaseDatabase.instance
                              .reference()
                              .child("Social Media Data")
                              .child(widget.post.uid)
                              .child(widget.post.postID)
                              .child("comments")
                              .update({
                            FirebaseAuth.instance.currentUser.uid: {
                              "comment": comment.text,
                              "imageURL": user.imageUrl,
                              "name": user.name,
                            }
                          });
                          comment.clear();
                          setState(() {
                            FocusScope.of(context).unfocus();
                          });
                        } catch (e) {
                          print(e);
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: theme.colorDefaultText,
                      ),
                    ),
                    hintText: 'Add a Comment',
                    border: InputBorder.none,
                  ),
                  controller: comment,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
