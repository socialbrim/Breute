import 'package:firebase_auth/firebase_auth.dart';
import 'package:parentpreneur/Screens/ComingSoonScreen.dart';
import 'package:parentpreneur/Screens/Pharmacy/CartScreen.dart';
import 'package:parentpreneur/Screens/Pharmacy/ProductsListScreen.dart';
import 'package:parentpreneur/Screens/social%20media/SocialMediaHomeScreen.dart';
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ComingSoon(
                                title: "Telehealth",
                              ),
                            ));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Icon(
                                MdiIcons.phone,
                                color: theme.colorPrimary,
                                size: 30,
                              ),
                              SizedBox(
                                width: width * 0.07,
                              ),
                              Container(
                                child: Text(
                                  'Telehealth',
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductsListScreen(
                                isSort: false,
                              ),
                            ));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Icon(
                                MdiIcons.pill,
                                color: theme.colorPrimary,
                                size: 30,
                              ),
                              SizedBox(
                                width: width * 0.07,
                              ),
                              Container(
                                child: Text(
                                  'Pharmacy',
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
                                builder: (context) => SocialMediaHomeScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Icon(
                                Icons.people,
                                color: theme.colorPrimary,
                                size: 30,
                              ),
                              SizedBox(
                                width: width * 0.07,
                              ),
                              Container(
                                child: Text(
                                  "Socials",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "©️ 2021 Breute | ",
                      style: theme.text14boldPimary,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TermsofUseScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Terms |",
                        style: theme.text14boldPimary,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen(),
                          ),
                        );
                      },
                      child: Text(
                        " Privacy ",
                        style: theme.text14boldPimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
