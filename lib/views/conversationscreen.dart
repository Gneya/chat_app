import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // Widget ChatMessageList() {
  //   return
  // }
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
          child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 13,
              margin: EdgeInsets.only(top: 12, bottom: 22, left: 10, right: 10),
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
                          //controller: searchTextEditingController,
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
