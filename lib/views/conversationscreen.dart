import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 13),
                      width: 250,
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
                    icon: Icon(Icons.send),
                    onPressed: () {
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
  const MessageTile({required this.message, required this.sendByMe});

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
            child: Text(
              message,
              style: TextStyle(color: sendByMe ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
