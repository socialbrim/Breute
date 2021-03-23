import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Screens/BetaUserTest.dart';
import 'package:parentpreneur/Screens/social%20media/SocialMediaHomeScreen.dart';
import '../main.dart';
import './RoomsScreen.dart';
import 'package:provider/provider.dart';
import '../Providers/User.dart';
import '../models/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class CustomerSupport extends StatefulWidget {
  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  UserInformation user;
  @override
  void didChangeDependencies() {
    user = Provider.of<UserProvider>(context).userInformation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text(
            'Social',
          ),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Image.asset(
                    'assets/Path.png',
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * .01,
                  ),
                  Center(
                    child: Container(
                      height: height * 0.2,
                      child: Image.asset(
                        'assets/1.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  GestureDetector(
                    onTap: () {
                      print(user);
                      print(user.bio);
                      if (user.bio == null ||
                          user.name == null ||
                          user.phone == null ||
                          user.email == null) {
                        Fluttertoast.showToast(
                            msg: "Please complete Your profile to continue");
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SocialMediaHomeScreen(),
                        ),
                      );
                    },
                    child: Card(
                      // color: HexColor('ffd7db'),
                      elevation: 20,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              HexColor('52a199'),
                              HexColor('0f7e86'),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.accountMultiple,
                                  color: theme.colorBackground,
                                  size: 45,
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: Text(
                                      'Connect With Friends',
                                      style: theme.text16boldWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .025,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (user.bio == null ||
                          user.name == null ||
                          user.phone == null ||
                          user.email == null) {
                        Fluttertoast.showToast(
                            msg: "Please complete Your profile to continue");
                        return;
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RoomsScreen(),
                        ),
                      );
                    },
                    child: Card(
                      color: HexColor('c1e5e2'),
                      elevation: 20,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              HexColor('52a199'),
                              HexColor('0f7e86'),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.accountMultiplePlus,
                                  color: theme.colorBackground,
                                  size: 45,
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: Text(
                                      'Rooms',
                                      style: theme.text16boldWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .025,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (user.bio == null ||
                          user.name == null ||
                          user.phone == null ||
                          user.email == null) {
                        Fluttertoast.showToast(
                            msg: "Please complete Your profile to continue");
                        return;
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BetaTest(),
                        ),
                      );
                    },
                    child: Card(
                      color: HexColor('c1e5e2'),
                      elevation: 20,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              HexColor('52a199'),
                              HexColor('0f7e86'),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.beta,
                                  color: theme.colorBackground,
                                  size: 45,
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    child: Text(
                                      'AI Beta',
                                      style: theme.text16boldWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
