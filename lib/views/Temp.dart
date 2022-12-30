import 'dart:async';

import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../helper/contants.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  bool isLoading = false;
  getUserInfo() async {
    Constant.myname = (await HelperFunctions.getUserNameSharedPreference())!;
  }

  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    getUserInfo();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    });
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  AuthMethods authMethods = new AuthMethods();
  @override
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
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ));
  }
}
