import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  const SignIn({required this.toggle});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  @override
  final _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  // signIn() {
  //   if (_formKey.currentState!.validate()) {
  //     HelperFunctions.saveUserEmailSharedPreference(
  //         emailTextEditingController.text);
  //     setState(() {
  //       isLoading = true;
  //     });
  //     databaseMethods
  //         .getUserByEmail(emailTextEditingController.text)
  //         .then((val) {
  //       snapshotUserInfo = val;
  //       print(snapshotUserInfo!.docs[0].get("name"));
  //       HelperFunctions.saveUserNameSharedPreference(
  //           snapshotUserInfo!.docs[0].get("name"));
  //       HelperFunctions.saveuserLoggedInSharedPreference(true);
  //       print("Here");
  //       authMethods.SignInWithEmailandPassword(emailTextEditingController.text,
  //               passwordTextEditingController.text)
  //           .then((value) => () async {
  //                 print("Hellooooooooooooooooooooo");
  //                 if (value != null) {
  //                   Navigator.pushReplacement(context,
  //                       MaterialPageRoute(builder: (context) => ChatRoom()));
  //                 } else {
  //                   isLoading = false;
  //                 }
  //               });
  //     });
  //     print("Hello");
  //   }
  // }
  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods.SignInWithEmailandPassword(
              emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot<Map<String, dynamic>>? snapshotUserInfo =
              await DatabaseMethods()
                  .getUserByEmail(emailTextEditingController.text);

          HelperFunctions.saveuserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo!.docs[0].get("name"));
          HelperFunctions.saveUserEmailSharedPreference(
              snapshotUserInfo!.docs[0].get("email"));

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            body: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
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
                // ignore: prefer_const_literals_to_create_immutables
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 140, left: 30),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, left: 30),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Welcome Back",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Enter valid Email-ID!!!!";
                            },
                            controller: emailTextEditingController,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              hintText: "Email id",
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.isEmpty || val.length < 6
                                  ? "Password must be alteast 6 characters!!!!"
                                  : null;
                            },
                            controller: passwordTextEditingController,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.key,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.only(right: 30),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.white),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: Container(
                            height: 50,
                            width: queryData.size.width / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          height: 50,
                          width: queryData.size.width / 1.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggle();
                                  },
                                  child: Container(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                )),
          );
  }
}
