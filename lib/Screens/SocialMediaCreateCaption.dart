import 'dart:html';

import 'package:flutter/material.dart';

import '../main.dart';

class SocialMediaCreateCaption extends StatefulWidget {
  String image;

  SocialMediaCreateCaption({this.image});

  @override
  _SocialMediaCreateCaptionState createState() =>
      _SocialMediaCreateCaptionState();
}

class _SocialMediaCreateCaptionState extends State<SocialMediaCreateCaption> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Caption'),
          actions: [
            InkWell(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => SocialMediaCreateCaption(
                //         // image: "${Image.file(File(image))}",
                //         ),
                //   ),
                // );
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .2,
                child: Text(
                  'Next >',
                  style: theme.text16Primary,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * .05,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorDefaultText,
                      ),
                    ),
                    height: height * 0.1,
                    width: width * .3,
                    // width: ,
                    child: Image.file(File(widget.image),
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Text(
                    'New Post',
                    style: theme.text20,
                  )
                ],
              ),
              SizedBox(
                height: height * .05,
              ),
              Container(
                height: height * .03,
                child: Text(
                  'Add Caption',
                  style: theme.text20boldPrimary,
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  // height: height * .3,
                  width: width * .8,
                  decoration: BoxDecoration(
                    border: Border.all(
                        // color: theme.colorGrey,
                        ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Caption',
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
