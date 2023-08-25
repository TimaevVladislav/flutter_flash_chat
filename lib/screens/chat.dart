import 'package:flutter/material.dart';
import 'package:flutter_chat/store/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String route = "chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController messageController = TextEditingController();
  late User logged;
  late String message;
  bool isOwnMessage = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await auth.currentUser;
    if (user != null) {
      logged = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          String title = snapshot.data!.docs[index]['title'].toString();
                          String user = snapshot.data!.docs[index]['user'].toString();

                          if (user == logged.email) {
                            isOwnMessage = true;
                          }

                          return Padding(padding: EdgeInsets.all(10.0),
                              child: Column(crossAxisAlignment: isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(user, style: TextStyle(fontSize: 12.0, color: Colors.black54)),
                                    Material(elevation: 5.0, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)), color: isOwnMessage ? Colors.lightBlueAccent : Colors.white, child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), child: Text(title, style: TextStyle(color: isOwnMessage ? Colors.white : Colors.black54, fontSize: 15.0),)))]));
                        }));
                  }

                  return Center(child: CircularProgressIndicator(backgroundColor: Colors.lightBlueAccent));
                },
                stream: firestore.collection("messages").snapshots()),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration),
                  ),
                  FilledButton(
                    onPressed: () {
                      firestore.collection("messages").add({"title": message, "user": logged.email});
                      messageController.clear();
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
