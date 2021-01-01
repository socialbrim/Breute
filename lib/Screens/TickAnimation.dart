import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'HomeScreen.dart';

class TickAnimation extends StatefulWidget {
  @override
  _TickAnimationState createState() => _TickAnimationState();
}

class _TickAnimationState extends State<TickAnimation> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/Tick.json',
          ),
        ),
      ),
    );
  }
}
