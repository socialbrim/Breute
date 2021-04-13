import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  String title;
  ComingSoon({this.title});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/3.png"),
                Text(
                  "coming soon",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
