import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';

import 'package:storage_path/storage_path.dart';
import '../models/creatPost.dart';

import '../main.dart';

class SocialMediaCreatePost extends StatefulWidget {
  SocialMediaCreatePost({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SocialMediaCreatePostState createState() => _SocialMediaCreatePostState();
}

class _SocialMediaCreatePostState extends State<SocialMediaCreatePost> {
  List<FileModel> files = [];
  FileModel selectedModel;
  String image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    setState(() {
      _isLoading = true;
    });
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
        _isLoading = false;
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: DropdownButtonHideUnderline(
            child: DropdownButton<FileModel>(
              items: getItems(),
              isExpanded: true,
              onChanged: (FileModel d) {
                assert(d.files.length > 0);
                image = d.files[0];
                setState(() {
                  selectedModel = d;
                });
              },
              value: selectedModel,
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: SpinKitFadingCircle(
                  color: theme.colorPrimary,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.42,
                      child: image != null
                          ? Image.file(File(image),
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width)
                          : Container(),
                    ),
                    Divider(),
                    selectedModel == null && selectedModel.files.length < 1
                        ? Container()
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.38,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4),
                                itemBuilder: (_, i) {
                                  var file = selectedModel.files[i];
                                  return GestureDetector(
                                    child: Image.file(
                                      File(file),
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        image = file;
                                      });
                                    },
                                  );
                                },
                                itemCount: selectedModel.files.length),
                          )
                  ],
                ),
              ),
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.folder,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:storage_path/storage_path.dart';
// import '../models/creatPost.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Instagrm picker demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<FileModel> files;
//   FileModel selectedModel;
//   String image;
//   @override
//   void initState() {
//     super.initState();
//     getImagesPath();
//   }

//   getImagesPath() async {
//     var imagePath = await StoragePath.imagesPath;
//     var images = jsonDecode(imagePath) as List;
//     files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
//     if (files != null && files.length > 0)
//       setState(() {
//         selectedModel = files[0];
//         image = files[0].files[0];
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
// //     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Icon(Icons.clear),
//                     SizedBox(width: 10),
//                     DropdownButtonHideUnderline(
//                         child: DropdownButton<FileModel>(
//                       items: getItems(),
//                       onChanged: (FileModel d) {
//                         assert(d.files.length > 0);
//                         image = d.files[0];
//                         setState(() {
//                           selectedModel = d;
//                         });
//                       },
//                       value: selectedModel,
//                     ))
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Next',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 )
//               ],
//             ),
//             Divider(),
//             Container(
//                 height: MediaQuery.of(context).size.height * 0.45,
//                 child: image != null
//                     ? Image.file(File(image),
//                         height: MediaQuery.of(context).size.height * 0.45,
//                         width: MediaQuery.of(context).size.width)
//                     : Container()),
//             Divider(),
//             selectedModel == null && selectedModel.files.length < 1
//                 ? Container()
//                 : Container(
//                     height: MediaQuery.of(context).size.height * 0.38,
//                     child: GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4,
//                             crossAxisSpacing: 4,
//                             mainAxisSpacing: 4),
//                         itemBuilder: (_, i) {
//                           var file = selectedModel.files[i];
//                           return GestureDetector(
//                             child: Image.file(
//                               File(file),
//                               fit: BoxFit.cover,
//                             ),
//                             onTap: () {
//                               setState(() {
//                                 image = file;
//                               });
//                             },
//                           );
//                         },
//                         itemCount: selectedModel.files.length),
//                   )
//           ],
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem> getItems() {
//     return files
//             .map((e) => DropdownMenuItem(
//                   child: Text(
//                     e.folder,
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   value: e,
//                 ))
//             .toList() ??
//         [];
// }
