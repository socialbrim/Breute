import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  var text = "";
  void fetchData() {
    FirebaseDatabase.instance
        .reference()
        .child("Privacy Policy")
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
              color: HexColor('FA163F'),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Privacy Policy",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: HexColor('091540'),
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
                    "Privacy Policy",
                    style: GoogleFonts.poppins(
                      color: HexColor('FA163F'),
                      fontWeight: FontWeight.bold,
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
                  child: Text(
                    "$text",
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      color: HexColor('091540'),
                      fontSize: 16,
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
