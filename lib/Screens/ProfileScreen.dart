import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';
import 'package:parentpreneur/auth/LoginScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';

import 'package:provider/provider.dart';
import '../main.dart';
import 'editProfile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInformation userData;
  @override
  void didChangeDependencies() {
    userData = Provider.of<UserProvider>(context).userInformation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.255,
              width: width,
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: userData.imageUrl == null
                          ? AssetImage("assets/unnamed.png")
                          : NetworkImage(userData.imageUrl),
                      radius: 80,
                    ),
                  ),
                  Positioned(
                    right: width * 0.04,
                    top: height * 0.015,
                    child: Container(
                      height: height * 0.07,
                      width: height * 0.07,
                      child: InkWell(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(height * 0.07)),
                          elevation: 5,
                          color: Colors.white,
                          child: Icon(
                            Icons.logout,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: width * 0.6,
                    bottom: height * 0.015,
                    child: CircleAvatar(
                      backgroundColor: theme.colorPrimary,
                      radius: 22,
                      child: Icon(
                        Icons.camera,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.21,
              color: theme.colorBackgroundGray,
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.014,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Username:',
                        overflow: TextOverflow.ellipsis,
                        style: theme.text16bold,
                      ),
                      Text(
                        userData.name == null
                            ? "Edit your Profile"
                            : userData.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.text14grey,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'E-mail:',
                        overflow: TextOverflow.ellipsis,
                        style: theme.text16bold,
                      ),
                      Text(
                        userData.email == null
                            ? "Edit your Profile"
                            : userData.email,
                        overflow: TextOverflow.ellipsis,
                        style: theme.text14grey,
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone:',
                        overflow: TextOverflow.ellipsis,
                        style: theme.text16bold,
                      ),
                      Text(
                        userData.phone == null
                            ? "Edit your Profile"
                            : userData.phone,
                        overflow: TextOverflow.ellipsis,
                        style: theme.text14grey,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
                // return;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  width: width * 0.45,
                  color: theme.colorPrimary,
                  child: Text(
                    'Edit Profile',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.text16boldWhite,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            InkWell(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  width: width * 0.7,
                  color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Edit Premium Plans',
                        // textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.text16boldWhite,
                      ),
                      Icon(
                        MdiIcons.crown,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
