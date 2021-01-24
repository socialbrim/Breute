import 'package:flutter/material.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';

import '../main.dart';
import 'editProfile.dart';
import './SocialMediaPostScreen.dart';

class SocialMediaProfileScreen extends StatefulWidget {
  @override
  _SocialMediaProfileScreenState createState() =>
      _SocialMediaProfileScreenState();
}

class _SocialMediaProfileScreenState extends State<SocialMediaProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/unnamed.png'),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Center(
              child: Text(
                'Harsh Mehta',
                style: theme.text20boldPrimary,
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            Container(
              width: width,
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Text(
                'Here, Bio will be displayed.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              },
              child: Container(
                width: width * .6,
                height: height * .04,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorGrey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Edit Profile',
                  style: theme.text14bold,
                ),
              ),
            ),
            SizedBox(
              height: height * .05,
            ),
            Divider(
              height: 0,
              color: theme.colorDefaultText,
            ),
            Container(
              height: height * .5,
              // height: count % 3 == 0
              //     ? (count / 3) * (height * .16)
              //     : count % 3 == 2
              //         ? ((count + 1) / 3) * (height * .16)
              //         : ((count + 2) / 3) * (height * .16),
              width: width,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SocialMediaPostScreen(),
                          ),
                        );
                      },
                      child: Image.network(
                        'https://assets.entrepreneur.com/content/3x2/2000/20200218153611-instagram.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 1,
            ),
          ],
        ),
      ),
    );
  }
}
