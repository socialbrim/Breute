import 'package:flutter/material.dart';
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

  Future<void> getcurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
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
      Future.delayed(Duration(seconds: 3)).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      });
    }
  }

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
