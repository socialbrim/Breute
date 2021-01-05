import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:parentpreneur/models/chatModel.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'package:provider/provider.dart';
import '../main.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  List<ChatModel> list;
  var key;
  ChatModel data;
  TextEditingController messageController = TextEditingController();
  String uid;

  void stream() {
    final user = FirebaseAuth.instance.currentUser;

    final ref = FirebaseDatabase.instance.reference().child("ChatRoom").onValue;
    ref.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      final chatdata = event.snapshot.value as Map;

      list = [];
      chatdata.forEach((key, value) {
        list.add(
          ChatModel(
            uid: value['uid'],
            message: value['message'],
            dateTime: DateTime.parse(
              value['timeStamp'],
            ),
            imageURL: value['DpURL'],
            nameOfCustomer: value['Name'],
          ),
        );
      });
      setState(() {
        list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        final temp = list.reversed;
        list = [];
        temp.forEach((element) {
          list.add(element);
        });
      });
    });
  }

  UserInformation userInfo;
  initState() {
    userInfo =
        Provider.of<UserProvider>(context, listen: false).userInformation;
    // uid = userInfo.id;
    stream();
    super.initState();
  }

  sendMessage() async {
    final filter = ProfanityFilter();
    print(filter.censor('${messageController.text}'));

    final ref = FirebaseDatabase.instance.reference().child("ChatRoom");
    final key = ref.push().key;
    ref.child(key).update({
      'message': filter.censor('${messageController.text}'),
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });
    messageController.text = '';
  }

  Widget chatMessageList() {
    return list != null
        ? Container(
            // height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
                reverse: true,
                itemCount: list.length,
                itemBuilder: (context, index) => MessageTile(
                      message: list[index].message,
                      isSendByMe: list[index].uid == userInfo.id,
                      imageURL: list[index].imageURL,
                      name: list[index].nameOfCustomer,
                    )),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        // bottomNavigationBar:
        // backgroundColor: Colors.blue[900],
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Chat with us'),
        ),
        body: Column(
          children: [
            Expanded(
              child: chatMessageList(),
            ),
            Container(
              color: theme.colorPrimary,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .75,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                        style: theme.text16Primary,
                        controller: messageController,
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Start Typing....',
                          hintStyle: theme.text16Primary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      if (messageController.text == null ||
                          messageController.text == "") {
                        Fluttertoast.showToast(
                            msg: "Write some message!",
                            gravity: ToastGravity.BOTTOM);
                        return;
                      }
                      return sendMessage();
                    },
                    child: messageController.text == null ||
                            messageController.text == ""
                        ? Text(
                            'Type',
                            style: theme.text16boldWhite,
                          )
                        : Icon(
                            Icons.send,
                            color: theme.colorBackground,
                          ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class MessageTile extends StatelessWidget {
  final bool isSendByMe;
  final String message;
  final String imageURL;
  String name;

  MessageTile({
    this.isSendByMe,
    this.message,
    this.imageURL,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? MediaQuery.of(context).size.width * .2 : 24,
          right: isSendByMe ? 24 : MediaQuery.of(context).size.width * .2),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorCompanion2,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft:
                        isSendByMe ? Radius.circular(15) : Radius.circular(0),
                    bottomRight:
                        isSendByMe ? Radius.circular(0) : Radius.circular(15)),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 12),
                child: isSendByMe
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$name',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  message,
                                  textAlign: isSendByMe
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: imageURL == null
                                ? AssetImage("assets/unnamed.png")
                                : NetworkImage(imageURL),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: imageURL == null
                                ? AssetImage("assets/unnamed.png")
                                : NetworkImage(imageURL),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name == null ? 'Anonymous' : "$name",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  message,
                                  textAlign: isSendByMe
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          // children: [
                          //   isSendByMe
                          //       ? Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             Text(
                          //               'Name',
                          //             ),
                          //             SizedBox(
                          //               width: width * 0.02,
                          //             ),
                          //             CircleAvatar(
                          //               radius: 10,
                          //               backgroundImage: imageURL == null
                          //                   ? AssetImage("assets/unnamed.png")
                          //                   : NetworkImage(imageURL),
                          //             ),
                          //           ],
                          //         )
                          //       : Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             CircleAvatar(
                          //               radius: 10,
                          //               backgroundImage: imageURL == null
                          //                   ? AssetImage("assets/unnamed.png")
                          //                   : NetworkImage(imageURL),
                          //             ),
                          //             SizedBox(
                          //               width: width * 0.02,
                          //             ),
                          //             Text(
                          //               'Name',
                          //             ),
                          //           ],
                          //         ),
                          //   Text(
                          //     message,
                          //     // textAlign: isSendByMe ? TextAlign.right : TextAlign.left,
                          //     style: GoogleFonts.poppins(
                          //       fontSize: 14,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
              ),
            ),
            // Positioned(
            //   top: 2,
            //   right: isSendByMe ? 2 : null,
            //   left: !isSendByMe ? 2 : null,
            // child: CircleAvatar(
            //   radius: 10,
            //   backgroundImage: imageURL == null
            //       ? AssetImage("assets/unnamed.png")
            //       : NetworkImage(imageURL),
            // ),
            // )
          ],
        ),
      ),
    );
  }
}
