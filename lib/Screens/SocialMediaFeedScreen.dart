import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './SocialMediaMsgScreen.dart';
import 'SocialMediaCommentScreen.dart';
import '../Screens/SearchScreen.dart';
import '../main.dart';
import '../models/PostModel.dart';

class SocialMediaFeedScreen extends StatefulWidget {
  @override
  _SocialMediaFeedScreenState createState() => _SocialMediaFeedScreenState();
}

class _SocialMediaFeedScreenState extends State<SocialMediaFeedScreen> {
  List<PostModel> _list = [];
  bool _isLoading = true;

  void fetchFeeds() async {
    final user = FirebaseAuth.instance.currentUser.uid;
    final friends = await FirebaseDatabase.instance
        .reference()
        .child("MyFriends")
        .child(user)
        .once();
    final mapped = friends.value as Map;
    if (mapped != null) {
      mapped.forEach((uid, _) async {
        final eachMemberPost = await FirebaseDatabase.instance
            .reference()
            .child("Social Media Data")
            .child(uid)
            .once();
        if (eachMemberPost.value != null) {
          final eachMap = await eachMemberPost.value as Map;
          eachMap.forEach((key, value) {
            if (key != "emial" &&
                key != "imageURL" &&
                key != "phone" &&
                key != "userName") {
              print(value['likeIDs']);
              _list.add(
                PostModel(
                  caption: value['caption'],
                  comments: value['comments'],
                  imageURl: eachMap['imageURL'],
                  likes: value['likes'],
                  name: eachMap['userName'],
                  postID: key,
                  postURL: value['image'],
                  uid: uid,
                  likeIDs: value['likeIDs'],
                  dateTime: value['dateTime'] == null
                      ? DateTime.now()
                      : DateTime.parse(
                          value['dateTime'],
                        ),
                ),
              );
            }
            setState(() {
              _isLoading = false;
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    fetchFeeds();
    super.initState();
  }

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

    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: theme.colorBackground,
            appBar: AppBar(
              title: Text(
                'Feed',
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
            body: Container(
              height: height * 0.9,
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return Container(
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
                              backgroundImage: _list[index].imageURl == null
                                  ? AssetImage('assets/unnamed.png')
                                  : NetworkImage(_list[index].imageURl),
                            ),
                            SizedBox(
                              width: width * .05,
                            ),
                            Text(
                              '${_list[index].name}',
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
                          width: width,
                          child: Image.network(
                            '${_list[index].postURL}',
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
                                    isLiked, _list[index]);
                              },
                              isLiked: isLiked(_list[index].likeIDs),
                              size: 28,
                              circleColor: CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc)),
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
                              likeCount: _list[index].likes == null
                                  ? 0
                                  : _list[index].likes,
                              countBuilder:
                                  (int count, bool isLiked, String text) {
                                var color = isLiked
                                    ? theme.colorDefaultText
                                    : Colors.grey;
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SocialMediaCommentScreen(
                                      post: _list[index],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '${_list[index].comments == null ? 0 : _list[index].comments.length} Comments',
                                style: theme.text14,
                              ),
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
                            '${_list[index].caption}',
                            style: theme.text14,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
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
