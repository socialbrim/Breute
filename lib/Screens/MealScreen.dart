import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parentpreneur/Screens/TodaysSelectedMeal.dart';
import 'package:parentpreneur/Widget/CameraView.dart';
import '../Screens/TodaysMeal.dart';
import '../Widget/DrawerWidget.dart';
import '../main.dart';
import 'Createmealscreen.dart';
import 'ProTipForWorkoutScreen.dart';
import '../Screens/ScheduleMeal.dart';

import './AllMeals.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Wellness'),
          actions: [
            IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                      // Pass the appropriate camera to the TakePictureScreen widget.
                      camera: firstCamera,
                    ),
                  ));
                })
          ],
        ),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: height * 0.15,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TodaysSelectedMeal(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        child: Image.asset(
                          'assets/todaymeals.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 5,
                        bottom: 5,
                        child: Card(
                          shadowColor: theme.colorPrimary,
                          color: theme.colorPrimary,
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Today Menu',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.15,
                width: double.infinity,
                child: InkWell(
                  splashColor: theme.colorCompanion,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProTipForWorkOutScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        child: Image.asset(
                          'assets/workout.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Card(
                          shadowColor: theme.colorPrimary,
                          color: theme.colorPrimary,
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Fitness',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.15,
                width: double.infinity,
                child: InkWell(
                  splashColor: theme.colorCompanion,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllMeals(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        child: Image.asset(
                          'assets/todaymeals.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 5,
                        bottom: 5,
                        child: Card(
                          shadowColor: theme.colorPrimary,
                          color: theme.colorPrimary,
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Recipes',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.15,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScheduleMeal(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        child: Image.asset(
                          'assets/schedule.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Card(
                          shadowColor: theme.colorPrimary,
                          color: theme.colorPrimary,
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Set Reminders ',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.15,
                width: double.infinity,
                child: InkWell(
                  splashColor: theme.colorCompanion,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateMealScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        child: Image.asset(
                          'assets/recipemeal.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 5,
                        bottom: 5,
                        child: Card(
                          shadowColor: theme.colorPrimary,
                          color: theme.colorPrimary,
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Add Recipe',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
