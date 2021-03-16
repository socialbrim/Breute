import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class BetaTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("AI Join Beta"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "If you would like to participate in our Ai Beta please click below to volunteer",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("congratulation"),
                          content: Text("Now are in list of Beta Testing"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        );
                      },
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
                          padding: EdgeInsets.all(10.0),
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
                                    'Participate in AI Beta',
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
                  height: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("congratulation"),
                          content: Text("Now are in list of Beta Testing"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        );
                      },
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
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Icon(
                                MdiIcons.listStatus,
                                color: theme.colorBackground,
                                size: 45,
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  child: Text(
                                    'Join Waiting List',
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
          ),
        ),
      ),
    );
  }
}
