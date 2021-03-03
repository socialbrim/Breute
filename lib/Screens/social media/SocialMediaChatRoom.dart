import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Screens/social media/SocialMediaProfileScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:parentpreneur/models/chatModel.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'package:provider/provider.dart';
import 'package:parentpreneur/main.dart';

// ignore: must_be_immutable
class SocialMediaChat extends StatefulWidget {
  String uid;
  UserInformation data;
  SocialMediaChat({this.uid, this.data});
  @override
  _SocialMediaChatState createState() => _SocialMediaChatState();
}

class _SocialMediaChatState extends State<SocialMediaChat> {
  List<ChatModel> list;
  var key;
  ChatModel data;
  TextEditingController messageController = TextEditingController();
  String uid;

  void stream() {
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;

    final ref = FirebaseDatabase.instance
        .reference()
        .child("ChatRoomPersonal")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(widget.uid)
        .onValue;
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
            messageID: key,
          ),
        );
      });
      if (this.mounted && context != null) {
        setState(() {
          list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          final temp = list.reversed;
          list = [];
          temp.forEach((element) {
            list.add(element);
          });
        });
      }
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
    final ref = FirebaseDatabase.instance.reference().child("ChatRoomPersonal");
    final key = ref.push().key;
    ref
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(widget.uid)
        .child(key)
        .update({
      'message': filter.censor('${messageController.text}'),
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });

    ref
        .child(widget.uid)
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(key)
        .update({
      'message': filter.censor('${messageController.text}'),
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });

    FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(widget.uid)
        .update({"imageURL": widget.data.imageUrl, "name": widget.data.name});
    FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(widget.uid)
        .child(FirebaseAuth.instance.currentUser.uid)
        .update({"imageURL": userInfo.imageUrl, "name": userInfo.name});
    messageController.text = '';
  }

  Widget chatMessageList() {
    return list != null
        ? Container(
            child: ListView.builder(
                reverse: true,
                itemCount: list.length,
                itemBuilder: (context, index) => MessageTile(
                      message: list[index].message,
                      isSendByMe: list[index].uid == userInfo.id,
                      imageURL: list[index].imageURL,
                      name: list[index].nameOfCustomer,
                      id: list[index].messageID,
                    )),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // bottomNavigationBar:
          backgroundColor: theme.colorBackground,
          appBar: AppBar(
            // title: Text('Chat'),
            // backgroundColor: theme.colorCompanion,
            title: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SocialMediaProfileScreen(
                        uid: widget.data.id,
                        isme: false,
                      ),
                    ),
                  );
                },
                child: Text('${widget.data.name}')),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/chatBG.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
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
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 10,
                            bottom: 10,
                          ),
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
                              fillColor: theme.colorBackgroundDialog,
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
            ),
          )),
    );
  }
}

// ignore: must_be_immutable
class MessageTile extends StatelessWidget {
  final bool isSendByMe;
  final String message;
  final String imageURL;
  String name;
  final String id;

  MessageTile({
    this.isSendByMe,
    this.message,
    this.imageURL,
    this.name,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? MediaQuery.of(context).size.width * .2 : 20,
          right: isSendByMe ? 20 : MediaQuery.of(context).size.width * .2),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSendByMe
                      ? theme.colorCompanion3
                      : theme.colorCompanion2,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft:
                          isSendByMe ? Radius.circular(15) : Radius.circular(0),
                      bottomRight: isSendByMe
                          ? Radius.circular(0)
                          : Radius.circular(15)),
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
                                // Text(
                                //   name == null ? "Anonymous" : '$name',
                                //   style: GoogleFonts.roboto(
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Container(
                                  width: width * 0.63,
                                  child: Text(
                                    message,
                                    textAlign: isSendByMe
                                        ? TextAlign.left
                                        : TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            // CircleAvatar(
                            //   radius: 20,
                            //   backgroundImage: imageURL == null
                            //       ? AssetImage("assets/unnamed.png")
                            //       : NetworkImage(imageURL),
                            // ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CircleAvatar(
                            //   radius: 20,
                            //   backgroundImage: imageURL == null
                            //       ? AssetImage("assets/unnamed.png")
                            //       : NetworkImage(imageURL),
                            // ),
                            // SizedBox(
                            //   width: width * 0.03,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   name == null ? "Anonymous" : "$name",
                                //   style: GoogleFonts.roboto(
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Container(
                                  width: width * 0.63,
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
                          ],
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
