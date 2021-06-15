import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:provider/provider.dart';

import '../main.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    @required this.camera,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

enum FlashStatus { ON, OFF, Auto }

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  var flashStatus;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller.setFlashMode(FlashMode.auto);
    flashStatus = FlashStatus.Auto;
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                CameraPreview(_controller),
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: flashStatus == FlashStatus.Auto
                            ? Icon(Icons.flash_auto)
                            : flashStatus == FlashStatus.OFF
                                ? Icon(Icons.flash_off)
                                : Icon(Icons.flash_on),
                        onPressed: () {
                          if (flashStatus == FlashStatus.Auto) {
                            //...
                            _controller.setFlashMode(FlashMode.off);
                            setState(() {
                              flashStatus = FlashStatus.OFF;
                            });
                          } else if (flashStatus == FlashStatus.OFF) {
                            //...
                            _controller.setFlashMode(FlashMode.always);
                            setState(() {
                              flashStatus = FlashStatus.ON;
                            });
                          } else if (flashStatus == FlashStatus.ON) {
                            //...
                            _controller.setFlashMode(FlashMode.auto);
                            setState(() {
                              flashStatus = FlashStatus.Auto;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({@required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isAnalysing = true;
  Future<void> foodAPI(String imageURl) async {
    final resp = await http.post("https://food-vision.herokuapp.com/",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": "$imageURl"}));
    print(resp.statusCode);
    print(resp.body);
    setState(() {
      _isAnalysing = false;
    });
    final data = json.decode(resp.body) as Map;
    if (data != null && data['food'] != "") {
      // apiDetections = data;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Dish Detected!"),
          content: Container(
            height: 200,
            width: double.maxFinite,
            child: ListView(
              children: [
                ListTile(
                  title: Text("Dish"),
                  trailing: Text("${data['food']}"),
                ),
                ListTile(
                  title: Text("Calories"),
                  trailing: Text("${data['calories']}"),
                ),
                ListTile(
                  title: Text("carbohydrates"),
                  trailing: Text("${data['carbohydrates']}"),
                ),
                ListTile(
                  title: Text("proteins"),
                  trailing: Text("${data['proteins']}"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  final dataod =
                      Provider.of<UserProvider>(context, listen: false)
                          .achievedCalories;
                  setStepsToServer(
                      dataod + double.parse(data['calories'].toString()));
                  Provider.of<UserProvider>(context, listen: false)
                          .achievedCalories =
                      dataod + double.parse(data['calories'].toString());
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "OK",
                  style: theme.text12bold,
                ))
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Dish not detected!"),
          content: Text("clicked image not contain any dish"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "OK",
                style: theme.text12bold,
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    setToservers().then((value) => foodAPI(value));
    super.initState();
  }

  void setStepsToServer(double achievedcalories) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .reference()
        .child("Users Step")
        .child(user.uid)
        .child(
          formatDate(DateTime.now()),
        )
        .update({
      "DateTime": DateTime.now().toIso8601String(),
      "Calories": achievedcalories.toStringAsFixed(2),
    });
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  Future<String> setToservers() async {
    setState(() {
      _isAnalysing = true;
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child("CheckDaily Meal")
        .child("${FirebaseAuth.instance.currentUser.uid}")
        .child("${DateTime.now().toString()}" + ".jpg");
    await ref.putFile(File(widget.imagePath));

    final vals = await ref.getDownloadURL();
    return vals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.file(
                File(widget.imagePath),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save"))
            ],
          ),
          if (_isAnalysing)
            Container(
              width: double.maxFinite,
              height: double.infinity,
              color: Colors.black54.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  padding: EdgeInsets.all(30),
                  color: Colors.white,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
