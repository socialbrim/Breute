import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/models/UserModel.dart';

import 'package:provider/provider.dart';

import '../main.dart';
import 'HomeScreen.dart';
import '../auth/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    getcurrentUser();
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final data = await FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(user.uid)
        .once();
    final mapped = data.value as Map;

    if (mapped == null) {
      //...
      FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else if (mapped['userName'] == null) {
      UserInformation userData = new UserInformation(
          email: mapped['emial'],
          id: mapped['uid'],
          imageUrl: mapped['imageURL'],
          name: mapped['userName'],
          phone: mapped['phone'],
          isPhone: mapped['isPhone']);
      Provider.of<UserProvider>(context, listen: false).setUser(userData);
    } else {
      UserInformation userData = new UserInformation(
          email: mapped['emial'],
          id: mapped['uid'],
          imageUrl: mapped['imageURL'],
          name: mapped['userName'],
          phone: mapped['phone'],
          isPhone: mapped['isPhone']);
      Provider.of<UserProvider>(context, listen: false).setUser(userData);
    }
  }

  Future<void> getcurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    // await fetchCurrentLocation();
    if (user == null) {
      UserInformation userData = new UserInformation(
        email: null,
        id: null,
        imageUrl:
            "https://www.pngitem.com/pimgs/m/24-248235_user-profile-avatar-login-account-fa-user-circle.png",
        name: "Your Name",
        phone: null,
      );
      Provider.of<UserProvider>(context, listen: false).setUser(userData);

      Future.delayed(Duration(seconds: 3)).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      });

      return;
    }
    if (user != null) {
      await fetchUserInfo();
      Future.delayed(Duration(seconds: 3)).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      });
    }
  }
  // Future<void> fetchCurrentLocation() async {
  //   await Geolocator.checkPermission();
  //   final position = await Geolocator.getCurrentPosition();
  //   final currentLocation = LatLng(position.latitude, position.longitude);
  //   Provider.of<MainProvider>(context, listen: false)
  //       .setLocation(currentLocation);
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.colorBackground,
      body: Center(
        child: Container(
          height: height * 0.3,
          child: Image.asset(
            'assets/Logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
