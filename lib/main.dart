import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/views/Temp.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userLoggedIn;
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getuserLoggedInSharedPreference().then((value) => {
          setState(() {
            userLoggedIn = value;
            //Contant.myName=
            print(HelperFunctions.getUserNameSharedPreference());
          })
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or simply save your changes to "hot reload" in a Flutter IDE).
      //   // Notice that the counter didn't reset back to zero; the application
      //   // is not restarted.
      //   primarySwatch: Colors.amber,
      // ),
      home: userLoggedIn != null
          ? userLoggedIn == true
              ? Temp()
              : Authenticate()
          : Authenticate(),
    );
  }
}

class Blank extends StatefulWidget {
  const Blank({super.key});

  @override
  State<Blank> createState() => _BlankState();
}

class _BlankState extends State<Blank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
