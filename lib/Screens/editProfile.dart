import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:images_picker/images_picker.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/models/UserModel.dart';

import 'package:provider/provider.dart';
import '../main.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  bool _isLoading = false;
  File image;
  String imageNetwork;

  Future<void> picker() async {
    // ignore: unused_local_variable
    File document;
    var vals;
    // ignore: unused_local_variable
    var _imagesetting = false;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Container(
          height: 120,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Please choose an Image"),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
            ],
          ),
        ),
      ),
    );
    setState(() {
      if (vals == null) {
        return;
      }
      image = File(vals.first.thumbPath);
    });
  }

  bool _isUploadig = false;

  Future<void> saveButton() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isUploadig = true;
    });
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("CustomerDP")
          .child("${FirebaseAuth.instance.currentUser.uid}")
          .child("CustomerDP" + ".jpg");
      await ref.putFile(image);

      final vals = await ref.getDownloadURL();

      await FirebaseDatabase.instance
          .reference()
          .child("User Information")
          .child(FirebaseAuth.instance.currentUser.uid)
          .update({
        "userName": name.text,
        "emial": email.text,
        "phone": phone.text,
        "imageURL": vals,
        "bio": bio.text,
      });

      FirebaseDatabase.instance
          .reference()
          .child("Social Media Data")
          .child(FirebaseAuth.instance.currentUser.uid)
          .update({
        "userName": name.text,
        "emial": email.text,
        "phone": phone.text,
        "imageURL": vals,
        "bio": bio.text,
      });

      setState(() {
        _isUploadig = false;
      });
      UserInformation changes = new UserInformation(
        email: email.text,
        id: FirebaseAuth.instance.currentUser.uid,
        imageUrl: vals,
        name: name.text,
        phone: phone.text,
        isPhone: data.isPhone,
      );
      Provider.of<UserProvider>(context, listen: false).setUser(changes);

      Navigator.of(context).pop();
      return;
    }

    await FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(FirebaseAuth.instance.currentUser.uid)
        .update({
      "userName": name.text,
      "emial": email.text,
      "phone": phone.text,
      "bio": bio.text,
    });

    FirebaseDatabase.instance
        .reference()
        .child("Social Media Data")
        .child(FirebaseAuth.instance.currentUser.uid)
        .update({
      "userName": name.text,
      "emial": email.text,
      "phone": phone.text,
      "imageURL": data.imageUrl,
      "bio": bio.text,
    });

    setState(() {
      _isUploadig = false;
    });

    UserInformation changes = new UserInformation(
      email: email.text,
      id: FirebaseAuth.instance.currentUser.uid,
      imageUrl: data.imageUrl,
      name: name.text,
      phone: phone.text,
      bio: bio.text,
      isPhone: data.isPhone,
    );
    Provider.of<UserProvider>(context, listen: false).setUser(changes);
    Navigator.of(context).pop();
  }

  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  // bool _isLogedInWithGoogle = false;
  UserInformation data;
  @override
  void initState() {
    final dta =
        Provider.of<UserProvider>(context, listen: false).userInformation;
    data = dta;
    email.text = dta.email;
    name.text = dta.name;
    phone.text = dta.phone;
    imageNetwork = dta.imageUrl;
    bio.text = dta.bio;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: height * 0.255,
                width: width,
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: image == null && imageNetwork == null
                            ? AssetImage("assets/unnamed.png")
                            : imageNetwork != null && image == null
                                ? NetworkImage(imageNetwork)
                                : FileImage(image),
                        radius: 80,
                      ),
                    ),
                    Positioned(
                      left: width * 0.6,
                      bottom: height * 0.015,
                      child: CircleAvatar(
                        backgroundColor: theme.colorPrimary,
                        radius: 22,
                        child: GestureDetector(
                          onTap: () {
                            picker();
                          },
                          child: Icon(
                            Icons.camera,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.035,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    // vertical: 5,
                  ),
                  // height: height * 0.06,
                  width: width * 0.78,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorCompanion,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    // initialValue: name,
                    controller: name,
                    keyboardType: TextInputType.name,
                    style: theme.text16,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Enter in Field";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "username",
                      hintStyle: TextStyle(
                        color: theme.colorPrimary,
                      ),
                      border: InputBorder.none,
                      icon: Icon(
                        MdiIcons.accountOutline,
                        color: theme.colorCompanion,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    // vertical: 5,
                  ),
                  // height: height * 0.06,
                  width: width * 0.78,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorCompanion,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    // initialValue: name,
                    controller: email,

                    keyboardType: TextInputType.name,
                    style: theme.text16,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Enter in Field";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "email",
                      hintStyle: TextStyle(
                        color: theme.colorPrimary,
                      ),
                      border: InputBorder.none,
                      icon: Icon(
                        MdiIcons.at,
                        color: theme.colorCompanion,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    // vertical: 5,
                  ),
                  // height: height * 0.06,
                  width: width * 0.78,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorCompanion,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    // enabled: false,
                    controller: phone,
                    keyboardType: TextInputType.name,
                    style: theme.text16,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Enter in Field";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      hintText: "phone number",
                      hintStyle: TextStyle(color: theme.colorPrimary),
                      border: InputBorder.none,
                      icon: Icon(
                        MdiIcons.phone,
                        color: theme.colorCompanion,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    // vertical: 5,
                  ),
                  // height: height * 0.06,
                  width: width * 0.78,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorCompanion,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    // initialValue: name,
                    controller: bio,

                    keyboardType: TextInputType.name,
                    style: theme.text16,
                    // validator: (val) {
                    //   if (val.isEmpty) {
                    //     return "Enter in Field";
                    //   } else
                    //     return null;
                    // },
                    decoration: InputDecoration(
                      hintText: "Bio",
                      hintStyle: TextStyle(
                        color: theme.colorPrimary,
                      ),
                      border: InputBorder.none,
                      icon: Icon(
                        MdiIcons.bio,
                        color: theme.colorCompanion,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.045,
              ),
              InkWell(
                onTap: () {
                  saveButton();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    height: height * 0.05,
                    width: width * 0.45,
                    color: theme.colorPrimary,
                    child: _isUploadig
                        ? SpinKitThreeBounce(
                            color: Colors.white,
                          )
                        : Text(
                            'Submit',
                            // textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: theme.text16boldWhite,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
