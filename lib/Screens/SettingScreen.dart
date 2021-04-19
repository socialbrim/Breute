import 'package:flutter/material.dart';
import 'package:parentpreneur/Config/theme.dart';
import 'package:parentpreneur/main.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'PremiunPlan.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isNotificationON = false;
  bool _isLoading = false;
  String tokenID;
  Future<void> genNewToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    final token = await _firebaseMessaging.getToken();
    setState(() {
      this.tokenID = token;
    });
  }

  void checkNotification() {
    FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(FirebaseAuth.instance.currentUser.uid)
        .onValue
        .listen((event) {
      //...
      final map = event.snapshot.value as Map;
      _isNotificationON =
          map['Notification'] == null ? false : map['Notification'];
      setState(() {});
    });
  }

  @override
  void initState() {
    checkNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                SwitchListTile(
                  title: Text(
                    theme.darkMode ? 'Light Theme' : "Dark Theme",
                  ),
                  onChanged: (value) async {
                    setState(() {
                      _isLoading = true;
                    });
                    Provider.of<AppThemeData>(context, listen: false)
                        .changeDarkMode();
                    theme.changeDarkMode();
                    await Future.delayed(Duration(seconds: 2));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  value: theme.darkMode,
                  activeColor: Colors.grey,
                ),
                SwitchListTile(
                  activeColor: Colors.grey,
                  title: Text("Notifications"),
                  onChanged: (value) async {
                    //....
                    setState(() {
                      _isLoading = true;
                    });
                    if (value) {
                      await genNewToken();
                      FirebaseDatabase.instance
                          .reference()
                          .child("User Information")
                          .child(FirebaseAuth.instance.currentUser.uid)
                          .update({
                        "Notification": true,
                        "fcmtoken": tokenID,
                      });
                    } else {
                      FirebaseDatabase.instance
                          .reference()
                          .child("User Information")
                          .child(FirebaseAuth.instance.currentUser.uid)
                          .child("fcmtoken")
                          .remove();
                      FirebaseDatabase.instance
                          .reference()
                          .child("User Information")
                          .child(FirebaseAuth.instance.currentUser.uid)
                          .update({
                        "Notification": false,
                      });
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  value: _isNotificationON,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Plans(),
                    ));
                  },
                  title: Text("My Subscriptions"),
                )
              ],
            ),
            if (_isLoading)
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  padding: EdgeInsets.all(25),
                  color: theme.darkMode
                      ? Colors.white.withOpacity(0.85)
                      : Colors.black.withOpacity(0.85),
                  child: CircularProgressIndicator(
                    backgroundColor:
                        theme.darkMode ? Colors.white : Colors.black,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
