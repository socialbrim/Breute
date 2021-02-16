import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Screens/SocialMediaPostScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';
import './SocialMediaMsgScreen.dart';
import 'SocialMediaCommentScreen.dart';
import '../Screens/SearchScreen.dart';
import '../main.dart';
import '../models/PostModel.dart';
import 'package:provider/provider.dart';
import '../Providers/feedProvider.dart';

class SocialMediaFeedScreen extends StatefulWidget {
  @override
  _SocialMediaFeedScreenState createState() => _SocialMediaFeedScreenState();
}

class _SocialMediaFeedScreenState extends State<SocialMediaFeedScreen> {
  List<PostModel> _list = [];
  bool _isLoading = true;

  Future<void> fetchFeeds() async {
    final user = FirebaseAuth.instance.currentUser.uid;
    final friends = await FirebaseDatabase.instance
        .reference()
        .child("MyFriends")
        .child(user)
        .once();
    final mapped = friends.value as Map;
    _list = [];
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
            Provider.of<FeedProvider>(context, listen: false).setList = _list;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
      Future.delayed(Duration(seconds: 4)).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  UserInformation data;
  @override
  void didChangeDependencies() {
    data = Provider.of<UserProvider>(context).userInformation;
    _list = Provider.of<FeedProvider>(context).getData;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    fetchFeeds();
    super.initState();
  }

  bool isLiked(Map likeList) {
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
        : RefreshIndicator(
            color: Colors.black,
            backgroundColor: Colors.blue,
            onRefresh: () => fetchFeeds(),
            child: Scaffold(
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
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .03,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * .1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Hello,',
                                  style: GoogleFonts.poppins(
                                      color: Colors.blueGrey, fontSize: 14),
                                ),
                              ),
                              Container(
                                width: width * .5,
                                child: Text(
                                  data.name == null
                                      ? 'My Name !'
                                      : "${data.name.split(" ")[0].toUpperCase()} !",
                                  style: theme.text20bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: width * .1,
                          ),
                          Card(
                            shape: CircleBorder(),
                            elevation: 10,
                            child: CircleAvatar(
                              backgroundImage: data.imageUrl == null
                                  ? AssetImage('assets/unnamed.png')
                                  : NetworkImage(data.imageUrl),
                              radius: 38,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      _list.isEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Icon(MdiIcons.networkOff),
                                  ),
                                  Center(
                                    child: Text(
                                      "No New Feed, Add Friends to see their feeds!\nClick here to find friend",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: height * .59 * _list.length,
                              child: ListView.builder(
                                cacheExtent: 9999,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 12,
                                    ),
                                    elevation: 6,
                                    child: Container(
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
                                                backgroundImage: _list[index]
                                                            .imageURl ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/unnamed.png')
                                                    : NetworkImage(
                                                        _list[index].imageURl),
                                              ),
                                              SizedBox(
                                                width: width * .05,
                                              ),
                                              Text(
                                                _list[index].name == null
                                                    ? "Unknown"
                                                    : '${_list[index].name}',
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
                                            // height: height * .4,
                                            child: Image.network(
                                              '${_list[index].postURL}',
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 75),
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.black,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes
                                                          : null,
                                                    ),
                                                  ),
                                                );
                                              },
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
                                                isLiked: isLiked(
                                                    _list[index].likeIDs),
                                                size: 28,
                                                circleColor: CircleColor(
                                                    start: Color(0xff00ddff),
                                                    end: Color(0xff0099cc)),
                                                bubblesColor: BubblesColor(
                                                  dotPrimaryColor:
                                                      Color(0xff33b5e5),
                                                  dotSecondaryColor:
                                                      Color(0xff0099cc),
                                                ),
                                                likeBuilder: (bool isLiked) {
                                                  return Icon(
                                                    Icons.favorite,
                                                    color: isLiked
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    size: 28,
                                                  );
                                                },
                                                likeCount:
                                                    _list[index].likes == null
                                                        ? 0
                                                        : _list[index].likes,
                                                countBuilder: (int count,
                                                    bool isLiked, String text) {
                                                  var color = isLiked
                                                      ? theme.colorDefaultText
                                                      : Colors.grey;
                                                  Widget result;
                                                  if (count == 0) {
                                                    result = Text(
                                                      "0",
                                                      style: TextStyle(
                                                          color: color),
                                                    );
                                                  } else
                                                    result = Text(
                                                      text,
                                                      style: TextStyle(
                                                          color: color),
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: width * .8,
                                                padding: EdgeInsets.only(
                                                  left: 25,
                                                ),
                                                child: Text(
                                                  '${_list[index].caption}',
                                                  style: theme.text14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     Navigator.of(context).push(
                                              //       MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             SocialMediaPostScreen(
                                              //           postModel: _list[index],
                                              //         ),
                                              //       ),
                                              //     );
                                              //   },
                                              //   child: Text(
                                              //     'More >',
                                              //     style: theme.text14primary,
                                              //   ),
                                              // )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * .015,
                                          )
                                          // Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(
                        height: height * .02,
                      ),
                    ],
                  ),
                )),
          );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, PostModel data) async {
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
