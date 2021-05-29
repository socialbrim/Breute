import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_introduction_tooltip/flutter_introduction_tooltip.dart';

class Test extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Test> {
  String _platformVersion = 'Unknown';
  GlobalKey globalKey = GlobalKey();
  GlobalKey globalKey2 = GlobalKey();
  bool isShowing = false;
  bool isShowing2 = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void popAndNextTutorial(BuildContext context) {
    Navigator.pop(context);
    showTutorial2(context);
  }

  void showTutorial(BuildContext context) async {
    if (!isShowing) {
      new Timer(Duration(seconds: 1), () async {
        try {
          FlutterIntroductionTooltip.showTopTutorialOnWidget(
              context,
              globalKey,
              Colors.blue,
              () => popAndNextTutorial(context),
              "MAMA",
              "MAMA IS A LOREM IPSUM",
              "ALRIGHT");
          print("SHOWING");
          setState(() {
            isShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  void showTutorial2(BuildContext context) async {
    if (!isShowing2) {
      new Timer(Duration(milliseconds: 500), () async {
        try {
          FlutterIntroductionTooltip.showBottomTutorialOnWidget(
              context,
              globalKey2,
              Colors.blue,
              () => Navigator.pop(context),
              "MAMA",
              "MAMA IS A LOREM IPSUM",
              "ALRIGHT");
          print("SHOWING");
          setState(() {
            isShowing2 = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterIntroductionTooltip.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Container(
            child: FutureBuilder(
              future: Future.delayed(Duration(seconds: 2)),
              builder: (BuildContext context, snapShotData) {
                switch (snapShotData.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    return Container(
                      // height: 100,
                      child: TextFormField(
                        initialValue: "L1\nL1\nL1\nL1\nL1\nL1",
                        maxLines: 2,
                      ),
                    );
                  default:
                    return CircularProgressIndicator();
                }
              },
            ),
          )),
    );
  }
}
