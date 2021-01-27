import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../main.dart';

class SocialMediaPostScreen extends StatefulWidget {
  @override
  _SocialMediaPostScreenState createState() => _SocialMediaPostScreenState();
}

class _SocialMediaPostScreenState extends State<SocialMediaPostScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Post'),
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
                        LikeButton(
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
                          likeCount: 0,
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
                        'Here, caption will be displayed',
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
}
