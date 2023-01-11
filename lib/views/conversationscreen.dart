import 'dart:io';

import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ConversationScreen extends StatefulWidget {
  final String username;
  final String ChatRoomId;
  const ConversationScreen({
    required this.username,
    required this.ChatRoomId,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  var type = "text";
  File? image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedfile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedfile != null) {
        image = File(pickedfile.path);
      } else {
        print("No image picked");
      }
    });
  }

  bool isLoading = false;
  TextEditingController messageController = new TextEditingController();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("ChatRoom")
      .doc(Constant.chatRoomId)
      .collection("chats")
      .orderBy("time")
      .snapshots();

  DatabaseMethods _databaseMethods = new DatabaseMethods();
  Widget ChatMessageList() {
    return StreamBuilder(

        //  stream: chatMessageStream,
        stream: _usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.orange.shade600,
            ));
          } else {
            return Container(
              padding: EdgeInsets.only(top: 15),
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    QuerySnapshot<Object?>? snap = snapshot.data; // Snapshot
                    List<DocumentSnapshot> items =
                        snap!.docs; // List of Documents
                    DocumentSnapshot item = items[index];
                    return MessageTile(
                      message: item['message'],
                      type: item['type'],
                      sendByMe:
                          item['sendBy'] == Constant.myname ? true : false,
                    );
                  }),
            );
          }
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constant.myname,
        "type": type,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      _databaseMethods.addConversationMessage(widget.ChatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 5), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    // TODO: implement initState
    // print("Inside");
    // setState(() {
    //   chatMessageStream =
    //       _databaseMethods.getConversationMessage(widget.ChatRoomId);
    // });
    // print(chatMessageStream);

    //.then((value) {
    //   print(value);
    //   setState(() {
    //     chatMessageStream = value;
    //   });
    // });
    super.initState();
  }

  @override
  AuthMethods _authMethods = new AuthMethods();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          Container(
              padding: EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    _authMethods.SignOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
                  },
                  icon: Icon(Icons.exit_to_app)))
        ],
        title: Text(widget.username, style: TextStyle(fontSize: 22)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.orange, Colors.pink]),
          ),
        ),
      ),
      body: Container(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.3,
            child: ChatMessageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 13,
              margin: EdgeInsets.only(top: 12, bottom: 22, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withOpacity(0.3),
                //borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 13),
                      width: 200,
                      child: TextField(
                          controller: messageController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              // enabledBorder: OutlineInputBorder(),
                              border: InputBorder.none,
                              hintText: "Message...",
                              hintStyle: TextStyle(color: Colors.black)))),
                  IconButton(
                    padding: EdgeInsets.only(bottom: 0),
                    icon: Icon(Icons.image),
                    onPressed: () {
                      getImage().then((value) => {
                            showModalBottomSheet<void>(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.2,
                                  // color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Image.file(
                                            image!.absolute,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              // gradient: LinearGradient(
                                              //     begin: Alignment.topCenter,
                                              //     end: Alignment.bottomRight,
                                              //     colors: <Color>[
                                              //       Colors.orange,
                                              //       Colors.pink
                                              //     ]),
                                              color: Colors.orangeAccent),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          181, 255, 153, 0)),
                                              child: const Text('Send'),
                                              onPressed: () async {
                                                firebase_storage.Reference ref =
                                                    firebase_storage
                                                        .FirebaseStorage
                                                        .instance
                                                        .ref('/foldername' +
                                                            '1224');
                                                firebase_storage.UploadTask
                                                    uploadTask = ref.putFile(
                                                        image!.absolute);
                                                await Future.value(uploadTask);
                                                var newUrl =
                                                    await ref.getDownloadURL();
                                                messageController.text = newUrl;
                                                type = "image";
                                                sendMessage();
                                                Navigator.pop(context);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          });

                      //sendMessage();
                      //  initiateSeach();
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.only(bottom: 0),
                    icon: Icon(Icons.send),
                    onPressed: () {
                      type = "text";
                      sendMessage();
                      //  initiateSeach();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String type;
  const MessageTile(
      {required this.message, required this.type, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sendByMe ? EdgeInsets.only(right: 5) : EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          SizedBox(
            height: 2,
          ),
          Container(
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.all(Radius.circular(20)),
              borderRadius: sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
              gradient: sendByMe
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.1,
                        0.6,
                      ],
                      colors: [
                        Colors.orange.withOpacity(0.7),
                        Colors.pinkAccent,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.1,
                        0.6,
                      ],
                      colors: [
                        Colors.orange.withOpacity(0.2),
                        Colors.pinkAccent.withOpacity(0.2),
                      ],
                    ),
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(2),
            child: type == "image"
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(
                          message: message,
                        );
                      }));
                    },
                    child: Container(
                        height: 150, width: 150, child: Image.network(message)),
                  )
                : Text(
                    message,
                    style: TextStyle(
                        color: sendByMe ? Colors.white : Colors.black),
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String message;
  DetailScreen({required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'Hero',
            child: Image.network(
              message,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
