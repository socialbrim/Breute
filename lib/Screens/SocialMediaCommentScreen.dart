import 'package:flutter/material.dart';

import '../main.dart';

class SocialMediaCommentScreen extends StatefulWidget {
  @override
  _SocialMediaCommentScreenState createState() =>
      _SocialMediaCommentScreenState();
}

class _SocialMediaCommentScreenState extends State<SocialMediaCommentScreen> {
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
      // bottomNavigationBar: Container(
      //   // height: height * .08,
      //   width: width,
      //   padding: EdgeInsets.only(top: 5, bottom: 10, left: 13, right: 13),
      //   child: Container(
      //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      //     decoration: BoxDecoration(
      //       border: Border.all(),
      //       borderRadius: BorderRadius.circular(15),
      //     ),
      //     child: TextFormField(
      //       decoration: InputDecoration(
      //         hintText: 'Add a Comment',
      //         disabledBorder: InputBorder.none,
      //       ),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .03,
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
              height: height * .63,
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (context, index) {
                  return Container(
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
                          backgroundImage: AssetImage('assets/unnamed.png'),
                        ),
                        SizedBox(
                          width: width * .05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Devesh',
                              style: theme.text14bold,
                            ),
                            Container(
                              width: width * .7,
                              child: Text(
                                'Here, Comment will be displayed',
                                style: theme.text14,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              // height: height * .08,
              width: width,
              padding: EdgeInsets.only(top: 5, bottom: 10, left: 13, right: 13),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Add a Comment',
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
