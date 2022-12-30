import 'dart:ffi';

import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/views/conversationscreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../services/auth.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  AuthMethods authMethods = new AuthMethods();
  Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("ChatRoom")
      .where("users", arrayContains: Constant.myname)
      .snapshots();
  @override
  getUserInfo() async {
    Constant.myname = (await HelperFunctions.getUserNameSharedPreference())!;
  }

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
                      username: item['chatroomid']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constant.myname, ""),
                      chatroomid: item['chatroomid'],
                    );
                  }),
            );
          }
        });
  }

  @override
  void initState() {
    print(Constant.myname);
    // TODO: implement initState
    // getUserInfo().then((value) {
    //   _usersStream = FirebaseFirestore.instance
    //       .collection("ChatRoom")
    //       .where("users", arrayContains: Constant.myname)
    //       .snapshots();
    // });
    super.initState();
  }

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
                    authMethods.SignOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
                  },
                  icon: Icon(Icons.exit_to_app)))
        ],
        title: Text("Chats", style: TextStyle(fontSize: 25)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.orange, Colors.pink]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Icon(Icons.search),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.orange, Colors.pink]),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      body: ChatMessageList(),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String username;
  final String chatroomid;
  const MessageTile({required this.username, required this.chatroomid});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.1,
                0.6,
              ],
              colors: [
                Colors.orange.withOpacity(0.1),
                Colors.pinkAccent.withOpacity(0.1),
              ],
            ),
          ),
          child: InkWell(
            onTap: () {
              Constant.chatRoomId = chatroomid;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ConversationScreen(
                          username: username, ChatRoomId: chatroomid))));
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.1,
                        0.6,
                      ],
                      colors: [
                        Colors.orange.withOpacity(0.8),
                        Colors.pinkAccent.withOpacity(0.8),
                      ],
                    ),
                  ),
                  height: 50,
                  width: 50,
                  child: Center(
                      child: Text(
                    username[0].toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
                Container(
                  child: Text(
                    username,
                    style: TextStyle(fontSize: 17),
                  ),
                  margin: EdgeInsets.all(10),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 13,
        ),
      ],
    );
  }
}
