import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

import '../helper/authenticate.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;
  TextEditingController searchTextEditingController =
      new TextEditingController();
  initiateSeach() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomandStartConversation({required String username}) {
    if (username != Constant.myname) {
      print(username);
      print(Constant.myname);
      String? chatRoomId = getChatRoomId(username, Constant.myname!);
      print(chatRoomId);
      List<String?> users = [username, Constant.myname];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId!, chatRoomMap);
      Constant.chatRoomId = chatRoomId;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    username: username,
                    ChatRoomId: chatRoomId,
                  )));
    } else {
      print("You cannot text yourself");
    }
  }

  Widget SearchTile({required useremail, required username}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 5),
      // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              useremail,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        //  Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomandStartConversation(username: username);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
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
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Message",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black),
            ),
          ),
        )
      ]),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                  username: searchSnapshot!.docs[index].get("name"),
                  useremail: searchSnapshot!.docs[index].get("email"));
            })
        : Container(
            height: 10,
          );
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
                    _authMethods.SignOut();
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
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 15,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade400.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 13),
                      width: 250,
                      child: TextField(
                          controller: searchTextEditingController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              // enabledBorder: OutlineInputBorder(),
                              border: InputBorder.none,
                              hintText: "Search username..",
                              hintStyle: TextStyle(color: Colors.black)))),
                  IconButton(
                    padding: EdgeInsets.only(bottom: 0),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      initiateSeach();
                    },
                  ),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width, child: searchList())
          ],
        ),
      ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final String username;
//   final String useremail;
//   SearchTile({required this.username, required this.useremail});

//   @override
//   Widget build(BuildContext context) {

//   }
// }

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
