import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';
import 'PremiunPlan.dart';

class UpgradeplanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        body: Column(
          children: [
            // Text("Please Upgrade to Premium Version"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: width * 0.28,
                  height: height * .042,
                  decoration: BoxDecoration(
                    color: HexColor('e7f7fe'),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Try Now',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.08,
            ),
            Container(
              width: width,
              child: Text(
                'Upgrade',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.006,
            ),
            Container(
              width: width,
              child: Text(
                'to Premium',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Image.asset(
                'assets/Logo.png',
                height: height * 0.35,
              ),
            ),
            // Container(
            //   height: height * 0.35,
            //   color: Colors.blue,
            // )
            SizedBox(
              height: height * 0.08,
            ),
            InkWell(
              onTap: () {
                //
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Plans(),
                ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.06,
                  width: width * 0.7,
                  color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Upgrade to Premium',
                        // textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.text16boldWhite,
                      ),
                      Icon(
                        MdiIcons.crown,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: height * 0.05,
                child: Text(
                  'No Thanks',
                  style: GoogleFonts.poppins(
                    color: theme.colorDefaultText,
                    decoration: TextDecoration.underline,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
