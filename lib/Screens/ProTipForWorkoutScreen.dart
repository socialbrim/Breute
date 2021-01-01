import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/workoutModel.dart';
import '../main.dart';

class ProTipForWorkOutScreen extends StatefulWidget {
  @override
  _ProTipForWorkOutScreenState createState() => _ProTipForWorkOutScreenState();
}

class _ProTipForWorkOutScreenState extends State<ProTipForWorkOutScreen> {
  List<WorkoutModel> _list = [];
  bool _isLoading = true;

  void fetchProTips() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("WorkoutTips")
        .once()
        .timeout(
          Duration(
            seconds: 8,
          ),
        );
    if (data.value != null) {
      final mapped = data.value as Map;
      mapped.forEach((key, value) {
        final map = value as Map;
        map.forEach((key, value) {
          _list.add(
            WorkoutModel(
              date: value['date'] == null
                  ? DateTime.now()
                  : DateTime.parse(value['date']),
              des: value['Description'],
              id: key,
              imageURL: value['ImageURL'],
              name: value['Name'],
              vidLink: value['VideoLink'],
            ),
          );
        });
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    fetchProTips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        title: Text('Pro Tips for Workout'),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: theme.colorPrimary,
              ),
            )
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    SlimyCard(
                      color: theme.colorPrimary,
                      width: width * 0.8,
                      topCardHeight: height * 0.3,
                      bottomCardHeight: height * 0.4,
                      borderRadius: 15,
                      topCardWidget: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Text(
                                  '${index + 1}. ',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _list[index].name.toLowerCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              height: height * 0.18,
                              width: width * 0.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  _list[index].imageURL,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                          ],
                        ),
                      ),
                      bottomCardWidget: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: width * 0.03,
                            //     ),
                            //     Text(
                            //       "Video Link - ",
                            //       style: GoogleFonts.inter(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w700,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     Linkify(
                            //       onOpen: (link) async {
                            //         if (await canLaunch(link.url)) {
                            //           await launch(link.url);
                            //         } else {
                            //           throw 'Could not launch $link';
                            //         }
                            //       },
                            //       text: "${_list[index].vidLink}",
                            //       style: GoogleFonts.inter(
                            //         fontSize: 14,
                            //         fontStyle: FontStyle.italic,
                            //         decoration: TextDecoration.underline,
                            //         color: Colors.blue,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: height * 0.02,
                            // ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Text(
                                  "Description",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  MdiIcons.arrowDown,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              width: width * 0.7,
                              child: Text(
                                "${_list[index].des}",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      slimeEnabled: true,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Text(
                            "Video Link - ",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: theme.colorCompanion2,
                            ),
                          ),
                          Linkify(
                            onOpen: (link) async {
                              if (await canLaunch(link.url)) {
                                await launch(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            text: "${_list[index].vidLink}",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
