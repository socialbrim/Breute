import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Screens/CustomerSupport.dart';
import 'package:parentpreneur/auth/LoginScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';
import '../models/PlanDetail.dart';
import 'package:provider/provider.dart';
import '../Screens/TodaysMeal.dart';
import '../main.dart';
import 'MainHomeScreen.dart';
import 'MealScreen.dart';
import '../Providers/MyPlanProvider.dart';
import 'ProfileScreen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  bool isRedirectingFromLogin;
  HomeScreen({this.isRedirectingFromLogin});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalsteps;
  int achievedsteps;
  double totalcalories;
  double achievedcalories;
  int barIndex = 0;
  bool _isLoading = true;
  String morningTime = "8:15";
  String afternoonTime = "14:0";
  String eveTime = "19:0";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    fetchUserInfo();

    //... notifications

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
    flutterLocalNotificationsPlugin.cancelAll();
    fetchSchedule().then((value) {
      sendMorningsNotifications();
      sendLunchNotifications();
      sendDinnerNotifications();
    });
    //... notifications end

    super.initState();
  }

  Future<void> fetchSchedule() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("CustomSchedule")
        .child(FirebaseAuth.instance.currentUser.uid)
        .once();
    if (data.value == null) {
      //..
      final mySch =
          await FirebaseDatabase.instance.reference().child("schedule").once();
      if (mySch.value != null) {
        morningTime = mySch.value['Morning']['Time'] == null
            ? "8:15"
            : mySch.value['Morning']['Time'];
        afternoonTime = mySch.value['AfterNoon']['Time'] == null
            ? "14:0"
            : mySch.value['AfterNoon']['Time'];
        eveTime = mySch.value['Eve']['Time'] == null
            ? "19:0"
            : mySch.value['Eve']['Time'];
      }
    } else {
      morningTime = data.value['Morning'] == null
          ? "8:15"
          : data.value['Morning']['Time'];
      afternoonTime = data.value['AfterNoon'] == null
          ? "14:0"
          : data.value['AfterNoon']['Time'];
      eveTime = data.value['Eve'] == null ? "19:0" : data.value['Eve']['Time'];
    }
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => TodaysMeal()),
    );
  }

  Future<void> sendMorningsNotifications() async {
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      1,
      'Hey Wake Up!',
      'Time For a Morning Break Fast',
      _nextInstanceOfNextMorning(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          'daily notification description',
          importance: Importance.high,
          enableVibration: true,
        ),
      ),
      payload: "Morning one",
      androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  DateTime _nextInstanceOfNextMorning() {
    final splits = morningTime.split(":");
    DateTime now = DateTime.now();
    DateTime selectedDate = DateTime(now.year, now.month, now.day,
        int.parse(splits[0]), int.parse(splits[1]));
    if (selectedDate.isBefore(now)) {
      selectedDate = selectedDate.add(Duration(days: 1));
    }
    return selectedDate;
    //.....
  }

  Future<void> sendLunchNotifications() async {
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      2,
      'Hey!',
      'Time For Lunch!',
      _nextInstanceOfNextAfterNoon(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          'daily notification description',
          importance: Importance.high,
          enableVibration: true,
        ),
      ),
      androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  DateTime _nextInstanceOfNextAfterNoon() {
    final splits = afternoonTime.split(":");
    DateTime now = DateTime.now();
    DateTime selectedDate = DateTime(now.year, now.month, now.day,
        int.parse(splits[0]), int.parse(splits[1]));
    if (selectedDate.isBefore(now)) {
      selectedDate = selectedDate.add(Duration(days: 1));
    }
    return selectedDate;
    //.....
  }

  Future<void> sendDinnerNotifications() async {
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      3,
      'Hey',
      'Time For Dinner!',
      _nextInstanceOfNextEvening(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          'daily notification description',
          importance: Importance.high,
          enableVibration: true,
        ),
      ),
      androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  DateTime _nextInstanceOfNextEvening() {
    final splits = eveTime.split(":");
    DateTime now = DateTime.now();
    DateTime selectedDate = DateTime(now.year, now.month, now.day,
        int.parse(splits[0]), int.parse(splits[1]));
    if (selectedDate.isBefore(now)) {
      selectedDate = selectedDate.add(Duration(days: 1));
    }
    return selectedDate;
    //.....
  }

  PlanName planInfo;

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(user.uid)
        .onValue
        .listen((event) async {
      final mapped = event.snapshot.value as Map;

      if (mapped == null) {
        //...
        FirebaseAuth.instance.signOut();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
        return;
      }

      final plan = mapped['PlanName'];
      if (planInfo == null) {
        print(plan);
        final mappedPlan = await FirebaseDatabase.instance
            .reference()
            .child("Plans")
            .orderByChild("Name")
            .equalTo("$plan")
            .once();
        print(mappedPlan.value);
        final mappeddata = mappedPlan.value as Map;

        mappeddata.forEach((key, value) {
          planInfo = new PlanName(
            amount: value['amount'],
            des: value['description'],
            details: value['Details'],
            name: value['Name'],
          );
        });

        Provider.of<MyPlanProvider>(context, listen: false).setPlan(planInfo);
        UserInformation userData = new UserInformation(
          email: mapped['emial'],
          id: mapped['uid'],
          imageUrl: mapped['imageURL'],
          name: mapped['userName'],
          phone: mapped['phone'],
          isPhone: mapped['isPhone'],
          planDetails: planInfo,
        );
        Provider.of<UserProvider>(context, listen: false).setUser(userData);
        setState(() {
          _isLoading = false;
        });
      }
    });
    FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(user.uid)
        .update({"dateTime": DateTime.now().toIso8601String()});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: theme.colorPrimary,
                ),
              ),
            )
          : Scaffold(
              backgroundColor: theme.colorBackground,
              bottomNavigationBar: CurvedNavigationBar(
                buttonBackgroundColor: theme.colorBackground,
                index: barIndex,
                height: 60,
                color: theme.colorPrimary,
                backgroundColor: theme.colorBackground,
                onTap: (selectedindex) {
                  setState(() {
                    barIndex = selectedindex;
                  });
                },
                items: [
                  Icon(
                    MdiIcons.home,
                    color: barIndex == 0 ? theme.colorCompanion : Colors.black,
                  ),
                  Icon(
                    MdiIcons.fruitCherries,
                    color: barIndex == 1 ? theme.colorCompanion : Colors.black,
                  ),
                  Icon(
                    MdiIcons.account,
                    color: barIndex == 2 ? theme.colorCompanion : Colors.black,
                  ),
                  Icon(
                    MdiIcons.chat,
                    color: barIndex == 3 ? theme.colorCompanion : Colors.black,
                  ),
                ],
              ),
              body: barIndex == 0
                  ? MainHomeScreen()
                  : barIndex == 1
                      ? MealScreen()
                      : barIndex == 2
                          ? ProfileScreen()
                          : CustomerSupport(),
            ),
    );
  }
}
