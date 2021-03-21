import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/privacyPolicyScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Screens/TOUscreen.dart';
import '../Screens/social media/SocialMediaProfileScreen.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Screens/Createmealscreen.dart';
import 'package:parentpreneur/Screens/ProTipForWorkoutScreen.dart';
import 'package:parentpreneur/Screens/SettingScreen.dart';
import 'package:parentpreneur/auth/LoginScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:provider/provider.dart';
import '../Screens/ScheduleMeal.dart';
import '../main.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserInformation userData;
  // ignore: unused_field
  bool _isModChanging = false;
  @override
  void didChangeDependencies() {
    userData = Provider.of<UserProvider>(context).userInformation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Drawer(
          child: Container(
            color: theme.colorBackground,
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SocialMediaProfileScreen(
                            isme: true,
                            uid: FirebaseAuth.instance.currentUser.uid,
                          ),
                        ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: userData.imageUrl == null
                                ? AssetImage("assets/unnamed.png")
                                : NetworkImage(userData.imageUrl),
                            radius: 36,
                          ),
                          SizedBox(
                            width: width * 0.08,
                          ),
                          Column(
                            children: [
                              Container(
                                width: width * 0.42,
                                child: Text(
                                  userData.name == null
                                      ? "Edit your Profile"
                                      : userData.name.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.text18boldPrimary,
                                ),
                              ),
                              Container(
                                width: width * 0.42,
                                child: Text(
                                  userData.phone == null
                                      ? "No Number"
                                      : userData.phone,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.text12grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: theme.colorGrey,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.homeOutline,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'Home',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProTipForWorkOutScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.dumbbell,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'The Gym',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateMealScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.foodVariant,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'Create a Meal',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScheduleMeal(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.timerOutline,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'Schedule Meal',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SettingScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.tools,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            "Settings",
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TermsofUseScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.helpNetwork,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'Terms of service',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.shield,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'Privacy Policy',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Icon(
                          MdiIcons.logout,
                          color: theme.colorPrimary,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            'Logout',
                            style: theme.text16bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
