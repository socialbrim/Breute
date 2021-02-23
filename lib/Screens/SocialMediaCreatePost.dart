import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:io';
import 'package:parentpreneur/Screens/SocialMediaHomeScreen.dart';

import './SocialMediaCreateCaption.dart';
import 'package:images_picker/images_picker.dart';

import '../main.dart';

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
          RaisedButton.icon(
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
          RaisedButton.icon(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(MdiIcons.close),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SocialMediaHomeScreen(),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                if (image != null)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SocialMediaCreateCaption(
                        image: image, // image,
                      ),
                    ),
                  );
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
        body: fileImage == null
            ? Center(
                child: InkWell(
                  onTap: () {
                    picker();
                  },
                  child: Text(
                    "Pick an Image",
                    style: theme.text14bold,
                  ),
                ),
              )
            : Center(
                child: InkWell(
                  onTap: () {
                    picker();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.height * 0.5,
                    child: Image.file(
                      fileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
