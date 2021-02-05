import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../main.dart';
import 'ChatScreen.dart';
import './SocialMediaHomeScreen.dart';

// ignore: must_be_immutable
class CustomerSupport extends StatefulWidget {
  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text(
            'Support',
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
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: height * 0.2,
                      child: Image.asset(
                        'assets/#358_it_support_flatline.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Community Chat',
                      style: theme.text18bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Support(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 20,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Icon(
                                MdiIcons.messageTextOutline,
                                color: theme.colorCompanion,
                                size: 54,
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Chat with All',
                                    style: theme.text16bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SocialMediaHomeScreen(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 20,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Icon(
                                MdiIcons.accountMultiple,
                                color: theme.colorCompanion,
                                size: 54,
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Connect with your Friends',
                                    style: theme.text16bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.only(left: 40),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         child: Text(
                  //           "Support Timing",
                  //           style: GoogleFonts.poppins(
                  //             color: HexColor('091540'),
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Container(
                  //         child: Text(
                  //           'Monday-Saturday',
                  //           style: GoogleFonts.poppins(
                  //             color: HexColor('091540'),
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //       Container(
                  //         child: Text(
                  //           '10:00 AM - 6:00 PM',
                  //           style: GoogleFonts.poppins(
                  //             color: Colors.grey,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 2,
                  //       ),
                  //       Container(
                  //         child: Text(
                  //           '(Holidays during Festive season)',
                  //           style: GoogleFonts.poppins(
                  //             color: Colors.grey,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
