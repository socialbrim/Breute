import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Providers/socialmedialBarindex.dart';
import 'dart:io';
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:parentpreneur/main.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:provider/provider.dart';
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
  bool isNotStory = true;

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

  bool _isLoading = false;
  bool checkedValue = false;
  UserInformation data;
  @override
  void didChangeDependencies() {
    data = Provider.of<UserProvider>(context).userInformation;
    super.didChangeDependencies();
  }

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
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      height: 250,
                      child: Image.asset(
                        'assets/3.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: theme.colorPrimary,
                      onPressed: () {
                        isNotStory = true;
                        picker();
                      },
                      child: Text(
                        "Upload an Image",
                        style: theme.text14boldWhite,
                      ),
                    ),
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: theme.colorPrimary,
                      onPressed: () {
                        isNotStory = false;
                        picker();
                      },
                      child: Text(
                        "Upload an Story",
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
                        onPressed: () async {
                          if (image != null && isNotStory)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SocialMediaCreateCaption(
                                  image: image, // image,
                                ),
                              ),
                            );
                          else if (image != null && !isNotStory) {
                            File file = File(image);
                            final compFile = await compressImage(file);
                            final key = FirebaseDatabase.instance
                                .reference()
                                .child("Stories")
                                .child(FirebaseAuth.instance.currentUser.uid)
                                .push()
                                .key;
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child("Stories")
                                .child(
                                    "${FirebaseAuth.instance.currentUser.uid}")
                                .child("$key" + ".jpg");
                            await ref.putFile(compFile);
                            final vals = await ref.getDownloadURL();
                            FirebaseDatabase.instance
                                .reference()
                                .child("Stories")
                                .child(FirebaseAuth.instance.currentUser.uid)
                                .child(key)
                                .update({
                              "image": vals,
                              "name": data.name,
                              "Dp": data.imageUrl,
                              "dateTime": DateTime.now().toIso8601String(),
                            });
                            setState(() {
                              _isLoading = false;
                            });
                            Fluttertoast.showToast(
                                msg: "Story uploaded successfully");

                            Provider.of<BarIndexChange>(context, listen: false)
                                .setBarindex(0);
                          }
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
