import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Config/theme.dart';
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
                            'Pro Tips for Workout',
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
                      // setState(() {
                      //   _isModChanging = true;
                      // });
                      // Provider.of<AppThemeData>(context, listen: false)
                      //     .changeDarkMode();
                      // theme.changeDarkMode();
                      // Future.delayed(Duration(seconds: 2)).then((value) {
                      //   setState(() {
                      //     _isModChanging = false;
                      //   });
                      // });
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
                            // theme.darkMode ? 'Light Theme' : "Dark Theme",
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
                    onTap: () {},
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
        if (_isModChanging)
          Center(
            child: Container(
              height: 100,
              width: 100,
              padding: EdgeInsets.all(25),
              color: theme.darkMode
                  ? Colors.white.withOpacity(0.85)
                  : Colors.black.withOpacity(0.85),
              child: CircularProgressIndicator(
                backgroundColor: theme.darkMode ? Colors.white : Colors.black,
              ),
            ),
          )
      ],
    );
  }
}
