import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';
import './SocialMediaCreatePost.dart';
import './SocialMediaFeedScreen.dart';
import './SocialMediaProfileScreen.dart';

class SocialMediaHomeScreen extends StatefulWidget {
  @override
  _SocialMediaHomeScreenState createState() => _SocialMediaHomeScreenState();
}

class _SocialMediaHomeScreenState extends State<SocialMediaHomeScreen> {
  int barIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: theme.colorBackground,
          bottomNavigationBar: CurvedNavigationBar(
            buttonBackgroundColor: theme.colorBackground,
            index: barIndex,
            height: 60,
            color: theme.colorPrimary,
            backgroundColor: theme.colorBackground,
            onTap: (selectedindex) {
              setState(() {
                barIndex = selectedindex;
              });
            },
            items: [
              Icon(
                MdiIcons.home,
                color: barIndex == 0 ? theme.colorCompanion : Colors.black,
              ),
              Icon(
                MdiIcons.plusCircle,
                color: barIndex == 1 ? theme.colorCompanion : Colors.black,
              ),
              Icon(
                MdiIcons.account,
                color: barIndex == 2 ? theme.colorCompanion : Colors.black,
              ),
            ],
          ),
          body: barIndex == 0
              ? SocialMediaFeedScreen()
              : barIndex == 1
                  ? SocialMediaCreatePost()
                  : SocialMediaProfileScreen()),
    );
  }
}
