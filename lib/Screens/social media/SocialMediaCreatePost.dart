import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io';
import 'package:parentpreneur/main.dart';
import '../privacyPolicyScreen.dart';
import './SocialMediaCreateCaption.dart';
import 'package:images_picker/images_picker.dart';

import 'SearchScreen.dart';
import 'SocialMediaMsgScreen.dart';

class SocialMediaCreatePost extends StatefulWidget {
  SocialMediaCreatePost({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SocialMediaCreatePostState createState() => _SocialMediaCreatePostState();
}

class _SocialMediaCreatePostState extends State<SocialMediaCreatePost> {
  String image;
  File fileImage;

  Future<void> picker() async {
    // ignore: unused_local_variable
    File document;
    var vals;
    // ignore: unused_local_variable
    var _imagesetting = false;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Choose Image"),
        content: Text("Please choose an Image"),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("camera"),
            onPressed: () async {
              // ignore: deprecated_member_use
              vals = await ImagesPicker.openCamera(
                pickType: PickType.image,
                cropOpt: CropOption(
                  cropType: CropType.rect,
                ),
              );
              setState(() {
                _imagesetting = true;
              });
              Navigator.of(ctx).pop(true);
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.image),
            label: Text("gallery"),
            onPressed: () async {
              // ignore: deprecated_member_use
              vals = await ImagesPicker.pick(
                cropOpt: CropOption(
                  cropType: CropType.rect,
                ),
                count: 1,
                pickType: PickType.image,
              );
              setState(() {
                _imagesetting = true;
              });
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
    setState(() {
      if (vals == null) {
        return;
      }
      fileImage = File(vals.first.thumbPath);
      image = vals.first.thumbPath;
    });
  }

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        // appBar: AppBar(
        //   // leading: IconButton(
        //   //   icon: Icon(MdiIcons.close),
        //   //   onPressed: () => Navigator.of(context).pushReplacement(
        //   //     MaterialPageRoute(
        //   //       builder: (context) => SocialMediaHomeScreen(),
        //   //     ),
        //   //   ),
        //   // ),
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     InkWell(
        //       onTap: () async {
        //         if (image != null)
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (context) => SocialMediaCreateCaption(
        //                 image: image, // image,
        //               ),
        //             ),
        //           );
        //       },
        //       child: Container(
        //         alignment: Alignment.center,
        //         width: MediaQuery.of(context).size.width * .2,
        //         child: Text(
        //           'Next >',
        //           style: theme.text16Primary,
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Create Post',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ));
              },
            ),
            IconButton(
              icon: Icon(
                MdiIcons.facebookMessenger,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SocialMediaMsgScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: fileImage == null
            ? Column(
                children: [
                  Center(
                    child: Container(
                      height: 300,
                      child: Image.asset(
                        'assets/1.png',
                      ),
                    ),
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: theme.colorPrimary,
                      onPressed: () {
                        picker();
                      },
                      child: Text(
                        "Upload an Image",
                        style: theme.text14boldWhite,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Center(
                    child: InkWell(
                      onTap: () {
                        picker();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.file(
                          fileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  CheckboxListTile(
                    title: Text(
                        "By uploading images you agree to Breaute's terms of use and privacy statement."),
                    value: checkedValue,
                    checkColor: theme.colorBackground,
                    activeColor: theme.colorPrimary,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 73,
                        ),
                        Text(
                          "Click here to see privacy policy",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  if (checkedValue)
                    Center(
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        color: theme.colorPrimary,
                        onPressed: () {
                          if (image != null)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SocialMediaCreateCaption(
                                  image: image, // image,
                                ),
                              ),
                            );
                        },
                        child: Text(
                          "Next",
                          style: theme.text14boldWhite,
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
