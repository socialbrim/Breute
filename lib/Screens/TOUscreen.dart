import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class TermsofUseScreen extends StatefulWidget {
  @override
  _TermsofUseScreenState createState() => _TermsofUseScreenState();
}

class _TermsofUseScreenState extends State<TermsofUseScreen> {
  var text = "";
  void fetchData() {
    FirebaseDatabase.instance
        .reference()
        .child("Terms and Conditions")
        .onValue
        .listen((event) {
      text = event.snapshot.value["Text"];
      setState(() {});
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colorPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Terms & Conditions",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: theme.colorPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Terms of use",
                    style: GoogleFonts.poppins(
                      color: theme.colorPrimary,
                      fontSize: 22,
                    ),
                  ),
                ),
                Divider(
                  color: HexColor('091540'),
                  thickness: 1.5,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 300,
                    child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: "$text",
                      style: GoogleFonts.poppins(
                        color: HexColor('091540'),
                        fontSize: 16,
                      ),
                      linkStyle: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
