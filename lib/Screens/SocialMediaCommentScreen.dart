import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parentpreneur/Providers/feedProvider.dart';
import 'package:provider/provider.dart';
import '../models/PostModel.dart';
import '../main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Providers/User.dart';

// ignore: must_be_immutable
class SocialMediaCommentScreen extends StatefulWidget {
  PostModel post;
  SocialMediaCommentScreen({
    this.post,
  });
  @override
  _SocialMediaCommentScreenState createState() =>
      _SocialMediaCommentScreenState();
}

class _SocialMediaCommentScreenState extends State<SocialMediaCommentScreen> {
  TextEditingController comment = new TextEditingController();
  PostModel data;

  @override
  void didChangeDependencies() {
    data = Provider.of<FeedProvider>(context).getFiltered(widget.post.postID);
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
          child: Row(
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
        ));
      });
    }
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
                      backgroundImage: AssetImage('assets/unnamed.png'),
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
                      'Harsh Mehta',
                      style: theme.text16bold,
                    ),
                    Container(
                      width: width * .7,
                      child: Text(
                        'Here, caption will be displayed',
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
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefix: IconButton(
                      onPressed: () {
                        try {
                          final user =
                              Provider.of<UserProvider>(context, listen: false)
                                  .userInformation;
                          Map<String, Map<String, String>> data = {};
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

                          Provider.of<FeedProvider>(context, listen: false)
                              .setChangeInFeed(widget.post.postID, change);
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
                          setState(() {});
                        } catch (e) {
                          print(e);
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Add a Comment',
                    disabledBorder: InputBorder.none,
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
