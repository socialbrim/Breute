import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/main.dart';

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
                Container(width: 200, child: Image.asset("assets/3.png")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "subscribe for access.",
                          textAlign: TextAlign.center,
                          style: theme.text12bold,
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
                                  title: Text("Congratulation 👏"),
                                  content: Text(
                                      "We will notify you when Beta access becomes available."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Close",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
