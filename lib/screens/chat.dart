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
  late User logged;
  late String message;

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

  void storeMessage() async {
    if (message != "") {
      firestore.collection("messages").add({"title": message, "user": logged.email});
      message = "";
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
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          String title = snapshot.data!.docs[index]['title'].toString();
                          String user = snapshot.data!.docs[index]['user'].toString();

                          return Padding(padding: EdgeInsets.all(10.0), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[Text(user, style: TextStyle(fontSize: 12.0, color: Colors.black54)), Material(elevation: 5.0, borderRadius: BorderRadius.circular(30.0), color: Colors.lightBlueAccent, child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), child: Text("$title $user")))]));
                        });
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
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration),
                  ),
                  FilledButton(
                    onPressed: () {
                      storeMessage();
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
