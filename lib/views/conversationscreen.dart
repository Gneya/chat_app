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
  TextEditingController messageController = new TextEditingController();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("ChatRoom")
      .doc(Constant.chatRoomId)
      .collection("chats")
      .snapshots();

  DatabaseMethods _databaseMethods = new DatabaseMethods();
  Widget ChatMessageList() {
    return StreamBuilder(

        //  stream: chatMessageStream,
        stream: _usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                QuerySnapshot<Object?>? snap = snapshot.data; // Snapshot
                List<DocumentSnapshot> items = snap!.docs; // List of Documents
                DocumentSnapshot item = items[index];
                return MessageTile(
                  message: item['message'],
                );
              });
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageController.text,
        "sendBy": Constant.myname
      };
      _databaseMethods.addConversationMessage(widget.ChatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
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
            child: ChatMessageList(),
          ),
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
  const MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}
