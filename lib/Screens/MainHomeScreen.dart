import 'package:email_launcher/email_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:location/location.dart';
import 'package:parentpreneur/Providers/HomeScreenCtrl.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/models/UserModel.dart';
import '../Screens/UpgradePlanScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';
import 'package:provider/provider.dart';
import '../Providers/MyPlanProvider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/stepsModel.dart';
import '../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int totalsteps;
  int achievedsteps = 0;
  double achievedWater = 0;
  double totalcalories;
  double achievedcalories = 0;
  DateTime _stepDate = DateTime.now();
  int barIndex = 0;
  List<StepsModel> _list = [];

  bool _isAccessable = false;
  UserInformation userinfo;

  @override
  void didChangeDependencies() {
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "DashBoard" && value) {
        _isAccessable = true;
      }
    });

    userinfo = Provider.of<UserProvider>(context).userInformation;

    final boolean = Provider.of<HomeProvider>(context).isLoaded;

    if (context != null && !boolean) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        Provider.of<HomeProvider>(context, listen: false).setBool(true);
        read();
      });
    }
    super.didChangeDependencies();
  }

  bool _isLoading = true;
  void checkdata(UserInformation userinfo) {
    FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(FirebaseAuth.instance.currentUser.uid)
        .onValue
        .listen((event) {
      final mapped = event.snapshot.value;
      UserInformation userData = new UserInformation(
          email: mapped['emial'],
          id: mapped['uid'],
          imageUrl: mapped['imageURL'],
          name: mapped['userName'],
          phone: mapped['phone'],
          isPhone: mapped['isPhone'],
          weight: mapped['weight'] == null ? "0" : mapped['weight'],
          planDetails: userinfo.planDetails,
          bio: mapped['bio'],
          height: mapped['height'] == null ? "0" : mapped['height'],
          isVerified: mapped['verified'] == null ? false : mapped['verified']);
      Provider.of<UserProvider>(context, listen: false).setUser(userData);
    });
  }

  @override
  void initState() {
    checkpermission();
    fetchLocation();
    checkdata(
        Provider.of<UserProvider>(context, listen: false).userInformation);
    final now = DateTime.now();
    _dates.add(null);
    for (int i = 7; i >= 0; i--) {
      _dates.add(DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i)));
    }
    _dates.add(null);

    hasPermissions();

    super.initState();

    initPlatformState();
    fetchLastSevenDays();
  }

  void fetchLastSevenDays() {
    FirebaseDatabase.instance
        .reference()
        .child("Users Step")
        .child(FirebaseAuth.instance.currentUser.uid)
        .onValue
        .listen((event) {
      _list = [];
      final mapped = event.snapshot.value as Map;
      if (mapped != null) {
        mapped.forEach((key, value) {
          _list.add(
            StepsModel(
              calories: value['Calories'].toString(),
              date: DateTime.parse(
                value['DateTime'] == null
                    ? DateTime.now().toIso8601String()
                    : value['DateTime'],
              ),
              dateID: key,
              step: value['Steps'].toString(),
              achievedWater: value['Water'].toString(),
            ),
          );
        });
      }
      if (this.mounted) {
        setState(() {
          _list.forEach((element) {
            if (element.dateID == formatDate(DateTime.now()) &&
                achievedsteps == 0) {
              achievedcalories = double.parse(element.calories);
              achievedsteps = int.parse(element.step);
              achievedWater = element.achievedWater == null
                  ? 0
                  : double.parse(element.achievedWater);

              Provider.of<UserProvider>(context, listen: false)
                  .achievedCalories = achievedcalories;
              print(
                  "working-------------------------------------------------------- and done");
            }
          });
        });
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void fetchCalories() {
    double _step = achievedsteps * 0.045;
    if (this.mounted) {
      setState(() {});
    }
    setStepsToServer();
  }

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  void initPlatformState() {
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      if (this.mounted) {
        setState(() {
          if (event.x > 18 || event.y > 18 || event.z > 18) {
            achievedsteps++;
            _stepDate = DateTime.now();
            fetchCalories();
          }
        });
      }
    }));
  }

  final currentuser = FirebaseAuth.instance.currentUser;

  void setStepsToServer() {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .reference()
        .child("Users Step")
        .child(user.uid)
        .child(
          formatDate(_stepDate),
        )
        .update({
      "Steps": achievedsteps,
      "DateTime": _stepDate.toIso8601String(),
      "Calories": achievedcalories.toStringAsFixed(2),
      "Water": achievedWater.toStringAsFixed(2)
    });
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void checkpermission() async {
    var status = await Permission.activityRecognition.status;
    print(status);
    if (status.isUndetermined) {
      final data = await Permission.activityRecognition.request();
      print(status);
    }
    if (status.isGranted) {}
    if (status.isDenied) {
      // ignore: unused_local_variable
      final data = await Permission.activityRecognition.request();
      print(status);
    }
  }

  String result = '';
  Map<DataType, List<FitData>> results = Map();
  bool permissions;

  // ignore: unused_field
  RangeValues _dateRange = RangeValues(1, 8);
  // ignore: deprecated_member_use
  List<DateTime> _dates = List<DateTime>();

  Future<void> read() async {
    results.clear();

    try {
      permissions = await FitKit.requestPermissions(DataType.values);
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {
        for (DataType type in DataType.values) {
          try {
            results[type] = await FitKit.read(
              type,
              dateFrom: DateTime.now().subtract(Duration(days: 1)),
              dateTo: DateTime.now(),
              limit: null,
            );
          } on UnsupportedException catch (e) {
            results[e.dataType] = [];
          }
        }

        result = 'readAll: success';
        // print(results);
        print(results);
        print("---------------------");
        results.forEach((key, value) {
          if (key == DataType.ENERGY) {
            final vals = value.first.value;

            final dataconvert = double.parse("${vals.toString()}");
            if (this.mounted) {
              setState(() {
                achievedWater =
                    double.parse((dataconvert / 1000).toStringAsFixed(2));

                Provider.of<HomeProvider>(context, listen: false).savedData =
                    achievedWater;
              });
            }
          }
        });
      }
    } catch (e) {
      result = 'readAll: $e';
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> hasPermissions() async {
    try {
      permissions = await FitKit.hasPermissions(DataType.values);
    } catch (e) {
      result = 'hasPermissions: $e';
    }

    if (!mounted) return;
    if (this.mounted) {
      setState(() {});
    }
  }

  void fetchLocation() async {
    final permission = await Permission.location.status;
    if (permission.isUndetermined || permission.isDenied) {
      Permission.location.request();
    }
    final perr = await Permission.location.status;
    if (perr.isGranted) {
      final service = await Location.instance.requestService();
      if (service) {
        final getLocation = await Location.instance.getLocation();
        print("--------------------------------------------");
        print(getLocation.latitude);
        print(getLocation.longitude);
        print("--------------------------------------------");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).achievedWater =
        achievedWater;
    Provider.of<UserProvider>(context, listen: false).achievedsteps =
        achievedsteps.toDouble();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    totalsteps = 10000;
    totalcalories = 10000;
    var totalWater = 10;
    return _isLoading
        ? Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: theme.colorPrimary,
              ),
            ),
          )
        : !_isAccessable
            ? UpgradeplanScreen()
            : SafeArea(
                child: Scaffold(
                  backgroundColor: theme.colorBackground,
                  appBar: AppBar(
                    elevation: 6,
                    title: CircleAvatar(
                      backgroundImage: userinfo.imageUrl == null
                          ? NetworkImage("assets/unnamed.png")
                          : NetworkImage(userinfo.imageUrl),
                    ),
                    centerTitle: false,
                    actions: [
                      IconButton(
                          icon: Icon(MdiIcons.trophyAward),
                          onPressed: () async {
                            print(achievedsteps);
                            if (achievedsteps <= 10000) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      Text("Award unlocked at 10,000 steps."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              );
                              return;
                            }
                            final user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .userInformation;
                            Email email = Email(
                                to: ['test@gmail.com'],
                                subject: 'subject',
                                body:
                                    '$achievedsteps steps is done by ${user.name} with user id ${user.id} and want to take a reward');
                            await EmailLauncher.launch(email);
                          }),
                      IconButton(
                          icon: Icon(MdiIcons.water),
                          onPressed: () async {
                            print(achievedsteps);
                            if (achievedWater <= 8) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      "Award unlocked at 8 glass of water."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              );
                              return;
                            }
                            final user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .userInformation;
                            Email email = Email(
                                to: ['test@gmail.com'],
                                subject: 'subject',
                                body:
                                    '$achievedWater glass of water is taken by ${user.name} with user id ${user.id} and want to take a reward');
                            await EmailLauncher.launch(email);
                          })
                    ],
                  ),
                  drawer: DrawerWidget(),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Container(
                          height: height * 0.9,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.033,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      double changedValue;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              "Add cup of water.\n(Recommended 8 cups)"),
                                          content: TextFormField(
                                            initialValue:
                                                achievedWater.toString(),
                                            onChanged: (val) {
                                              changedValue = double.parse(val);
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Enter the Amount"),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("Users Step")
                                                    .child(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .child(
                                                      formatDate(_stepDate),
                                                    )
                                                    .update({
                                                  "Water": (changedValue +
                                                          achievedWater)
                                                      .toStringAsFixed(2),
                                                });
                                                setState(() {
                                                  achievedWater = changedValue +
                                                      achievedWater;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width * 0.45,
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      decoration: BoxDecoration(
                                        color: theme.colorBackground,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'WATER',
                                                style: GoogleFonts.ptMono(
                                                  color: theme.colorDefaultText,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              achievedsteps < totalsteps
                                                  ? Icon(
                                                      MdiIcons.trendingDown,
                                                      color:
                                                          theme.colorCompanion,
                                                    )
                                                  : Icon(MdiIcons.trendingUp)
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          CircularPercentIndicator(
                                            radius: height * 0.1,
                                            lineWidth: 8.0,
                                            animation: true,
                                            percent: achievedWater /
                                                (totalWater < achievedWater
                                                    ? achievedWater
                                                    : totalWater),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            center: Icon(
                                              MdiIcons.water,
                                              size: height * 0.05,
                                              color: theme.colorPrimary,
                                            ),
                                            progressColor: theme.colorPrimary,
                                            backgroundColor: theme.colorGrey,
                                          ),
                                          SizedBox(
                                            height: height * 0.022,
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: achievedWater.toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: theme.colorDefaultText,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' / $totalWater',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.033,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      double changedValue = achievedcalories;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              "Add Calories.\n(Recommended daily calorie intakes in the US are around 2,500 for men and 2,000 for women)"),
                                          content: TextFormField(
                                            initialValue:
                                                achievedcalories.toString(),
                                            onChanged: (va) {
                                              changedValue = double.parse(va);
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "Enter the Amount"),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                achievedcalories = changedValue;
                                                print(
                                                    "------------------------------------");
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("Users Step")
                                                    .child(FirebaseAuth.instance
                                                        .currentUser.uid)
                                                    .child(
                                                      formatDate(_stepDate),
                                                    )
                                                    .update({
                                                  "Calories": changedValue
                                                      .toStringAsFixed(2),
                                                });
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width * 0.45,
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      decoration: BoxDecoration(
                                        color: theme.colorBackground,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'CALORIES',
                                                style: GoogleFonts.ptMono(
                                                  color: theme.colorDefaultText,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              achievedcalories < totalcalories
                                                  ? Icon(
                                                      MdiIcons.trendingDown,
                                                      color:
                                                          theme.colorCompanion,
                                                    )
                                                  : Icon(
                                                      MdiIcons.trendingUp,
                                                      color:
                                                          theme.colorCompanion,
                                                    )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          CircularPercentIndicator(
                                            radius: height * 0.1,
                                            lineWidth: 8.0,
                                            percent: achievedcalories /
                                                (totalcalories <
                                                        achievedcalories
                                                    ? achievedcalories
                                                    : totalcalories),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            center: Icon(
                                              MdiIcons.food,
                                              size: height * 0.05,
                                              color: theme.colorPrimary,
                                            ),
                                            progressColor: theme.colorPrimary,
                                            backgroundColor: theme.colorGrey,
                                          ),
                                          SizedBox(
                                            height: height * 0.022,
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: achievedcalories
                                                    .toStringAsFixed(2),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: theme.colorDefaultText,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' / $totalcalories',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width * 0.9,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'STEPS',
                                          style: GoogleFonts.ptMono(
                                            color: theme.colorDefaultText,
                                            fontSize: 15,
                                          ),
                                        ),
                                        achievedsteps < totalsteps
                                            ? Icon(
                                                MdiIcons.trendingDown,
                                                color: theme.colorCompanion,
                                              )
                                            : Icon(MdiIcons.trendingUp)
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    CircularPercentIndicator(
                                      radius: height * 0.1,
                                      lineWidth: 8.0,
                                      animation: true,
                                      percent: achievedsteps /
                                          (totalsteps < achievedsteps
                                              ? achievedsteps
                                              : totalsteps),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      center: Icon(
                                        MdiIcons.shoePrint,
                                        size: height * 0.05,
                                        color: theme.colorPrimary,
                                      ),
                                      progressColor: theme.colorPrimary,
                                      backgroundColor: theme.colorGrey,
                                    ),
                                    SizedBox(
                                      height: height * 0.022,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: achievedsteps.toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: theme.colorDefaultText,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' / $totalsteps',
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width * 0.9,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    double changedValue;
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            "Add Height.(Enter the values in Meter)"),
                                        content: TextFormField(
                                          initialValue:
                                              achievedcalories.toString(),
                                          onChanged: (va) {
                                            changedValue = double.parse(va);
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: "Enter the Amount"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              print(changedValue);
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("User Information")
                                                  .child(FirebaseAuth
                                                      .instance.currentUser.uid)
                                                  .update({
                                                "height": changedValue
                                                    .toStringAsFixed(2),
                                              });
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  leading: Icon(Icons.height),
                                  title: Text(
                                    "Height",
                                    style: theme.text12bold,
                                  ),
                                  trailing: Text("${userinfo.height}"),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width * 0.9,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    double changedValue;
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            "Add weight.(Enter the values in lbs)"),
                                        content: TextFormField(
                                          initialValue:
                                              achievedcalories.toString(),
                                          onChanged: (va) {
                                            changedValue = double.parse(va);
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: "Enter the Amount"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              print(changedValue);
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("User Information")
                                                  .child(FirebaseAuth
                                                      .instance.currentUser.uid)
                                                  .update({
                                                "weight": changedValue
                                                    .toStringAsFixed(2),
                                              });
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  leading: Icon(Icons.line_weight),
                                  title: Text(
                                    "Weight",
                                    style: theme.text12bold,
                                  ),
                                  trailing: Text("${userinfo.weight}"),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width * 0.9,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  leading: Icon(MdiIcons.heart),
                                  title: Text(
                                    "Heart Rate",
                                    style: theme.text12bold,
                                  ),
                                  trailing: Text("78"),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width * 0.9,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  leading: Icon(MdiIcons.bed),
                                  title: Text(
                                    "Sleep",
                                    style: theme.text12bold,
                                  ),
                                  trailing: Text("8 Hrs."),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: height * 0.03,
                        // ),
                        Container(
                          height: height * 0.08,
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analysis',
                                style: GoogleFonts.poppins(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Last 7 Days',
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  // color: theme.colorGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.45,
                          child: ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  height: height * 0.06,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: theme.colorCompanion, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_list[index].date.day}/${_list[index].date.month}/${_list[index].date.year}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            '${DateFormat.EEEE().format(_list[index].date)}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Icon(
                                        MdiIcons.shoePrint,
                                        color: theme.colorPrimary,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        'Steps: ',
                                        style: GoogleFonts.roboto(
                                          color: theme.colorPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${_list[index].step}',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Icon(
                                        MdiIcons.food,
                                        color: theme.colorPrimary,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        'Calories: ',
                                        style: GoogleFonts.roboto(
                                          color: theme.colorPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${_list[index].calories}',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
