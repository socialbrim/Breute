import 'dart:io';
import 'package:parentpreneur/Providers/User.dart';

import 'package:parentpreneur/Providers/socialmedialBarindex.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:provider/provider.dart';
import 'package:parentpreneur/main.dart';

// ignore: must_be_immutable
class SocialMediaCreateCaption extends StatefulWidget {
  String image;

  SocialMediaCreateCaption({this.image});

  @override
  _SocialMediaCreateCaptionState createState() =>
      _SocialMediaCreateCaptionState();
}

class _SocialMediaCreateCaptionState extends State<SocialMediaCreateCaption> {
  String caption;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Caption'),
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
                    vertical: 6,
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
                    onChanged: (val) {
                      caption = val;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Caption',
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * .02),
              _isLoading
                  ? Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    )
                  : RaisedButton(
                      color: theme.colorPrimary,
                      elevation: 8,
                      child: Text(
                        "Upload Post",
                        style: theme.text14boldWhite,
                      ),
                      onPressed: () async {
                        if (caption == null || caption == "") {
                          Fluttertoast.showToast(
                              msg: "Please enter correct Caption");
                          return;
                        }
                        final user =
                            Provider.of<UserProvider>(context, listen: false)
                                .userInformation;
                        if (user.name == null) {
                          Fluttertoast.showToast(
                              msg: "Please complete your profile first");
                          return;
                        }
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          File file = File(widget.image);
                          final compFile = await compressImage(file);
                          final key = FirebaseDatabase.instance
                              .reference()
                              .child("Social Media Data")
                              .child(FirebaseAuth.instance.currentUser.uid)
                              .push()
                              .key;
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child("CustomerSocialMedial")
                              .child("${FirebaseAuth.instance.currentUser.uid}")
                              .child("$key" + ".jpg");
                          await ref.putFile(compFile);
                          final vals = await ref.getDownloadURL();
                          FirebaseDatabase.instance
                              .reference()
                              .child("Social Media Data")
                              .child(FirebaseAuth.instance.currentUser.uid)
                              .child(key)
                              .update({
                            "image": vals,
                            "caption": caption,
                            "dateTime": DateTime.now().toIso8601String(),
                          });
                          setState(() {
                            _isLoading = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Post uploaded successfully");

                          Navigator.of(context).pop();
                          Provider.of<BarIndexChange>(context, listen: false)
                              .setBarindex(0);
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "Something went wrong");
                          Navigator.of(context).pop();
                          Provider.of<BarIndexChange>(context, listen: false)
                              .setBarindex(0);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> compressImage(File images) async {
    File compressedimage;

    File imageFile = images;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());

    var compressedImage = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 20));
    compressedimage = compressedImage;

    return compressedimage;
  }
}
