import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';
import './SocialMediaMsgScreen.dart';
import 'SocialMediaCommentScreen.dart';

import '../main.dart';

class SocialMediaFeedScreen extends StatefulWidget {
  @override
  _SocialMediaFeedScreenState createState() => _SocialMediaFeedScreenState();
}

class _SocialMediaFeedScreenState extends State<SocialMediaFeedScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        title: Text(
          'Feed',
        ),
        actions: [
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
              height: height * 0.03,
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                height: height * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      MdiIcons.magnify,
                      size: 28,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * .6,
                      child: TextFormField(
                        cursorColor: theme.colorPrimary,
                        decoration: InputDecoration(
                          hintText: "Search Friend",
                          hintStyle: theme.text16,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              height: height * 0.69,
              child: ListView.builder(
                itemCount: 3,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
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
                              backgroundImage: AssetImage('assets/unnamed.png'),
                            ),
                            SizedBox(
                              width: width * .05,
                            ),
                            Text(
                              'Harsh Mehta',
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
                            'https://assets.entrepreneur.com/content/3x2/2000/20200218153611-instagram.jpeg',
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
                            // Icon(
                            //   Icons.favorite,
                            //   color: Colors.red,
                            //   size: 28,
                            // ),
                            LikeButton(
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
                              likeCount: 0,
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
                                        SocialMediaCommentScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                '19 Comments',
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
                            'Here, caption will be displayed',
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
            SizedBox(
              height: height * .05,
            ),
          ],
        ),
      ),
    );
  }
}
