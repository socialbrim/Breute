import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          title: Text('Meals'),
        ),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              // Container(
              //   height: height * 0.218,
              //   width: double.infinity,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 4,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 3, vertical: 15),
              //         child: Card(
              //           elevation: 9,
              //           shadowColor: theme.colorPrimary,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           child: Container(
              //             height: height * 0.2,
              //             width: width * 0.41,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.only(
              //                     topLeft: Radius.circular(10),
              //                     topRight: Radius.circular(10),
              //                   ),
              //                   child: Image.network(
              //                     'https://ca-times.brightspotcdn.com/dims4/default/ab332d5/2147483647/strip/true/crop/1800x1200+0+0/resize/1486x991!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2Fb7%2F6a%2Faf67a5ac4f28a7d245d7ba851366%2Fstrawberries.jpg',
              //                     fit: BoxFit.cover,
              //                     height: height * 0.11,
              //                     width: width * 0.41,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: height * 0.002,
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.only(left: 10),
              //                   child: Column(
              //                     // mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Container(
              //                         child: Text(
              //                           'Strawberry',
              //                           style: GoogleFonts.poppins(
              //                             fontSize: 14,
              //                           ),
              //                         ),
              //                       ),
              //                       Container(
              //                         child: Text(
              //                           '250 Calories',
              //                           style: GoogleFonts.roboto(
              //                             fontSize: 10,
              //                             color: Colors.grey,
              //                           ),
              //                         ),
              //                       )
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
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
                              'Meal Recipes',
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
                          'assets/workout.png',
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
                              'Pro Tips for Workout',
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
                        builder: (context) => TodaysMeal(),
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
                              'Today\'s Meal',
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
                          'assets/schedule.png',
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
                              'Schedule Meals',
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
                              'Create a Meal',
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
