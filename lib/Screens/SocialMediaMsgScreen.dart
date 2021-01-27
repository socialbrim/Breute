import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class SocialMediaMsgScreen extends StatefulWidget {
  @override
  _SocialMediaMsgScreenState createState() => _SocialMediaMsgScreenState();
}

class _SocialMediaMsgScreenState extends State<SocialMediaMsgScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Messages',
          ),
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: height * .03,
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorGrey,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 2,
                ),
                width: width * .9,
                height: height * .05,
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.magnify,
                    ),
                    SizedBox(
                      width: width * .06,
                    ),
                    Text(
                      'Search',
                      style: theme.text14,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                height: height * .8,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: width * .05,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('assets/unnamed.png'),
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
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
