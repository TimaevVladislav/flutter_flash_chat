import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/screens/chat.dart';
import 'package:flutter_chat/components/button.dart';
import 'package:flutter_chat/store/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String route = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  late String email;
  late String password;

  void setLoading(bool state) {
    setState(() {
      loading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                    tag: "logo",
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    )),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: inputDecoration.copyWith(hintText: "Enter your email"),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: inputDecoration.copyWith(hintText: "Enter your password"),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    title: "Log In",
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      try {
                        setLoading(true);
                        final user = await auth.signInWithEmailAndPassword(email: email, password: password);

                        if (user != null) {
                          setLoading(false);
                          Navigator.pushNamed(context, ChatScreen.route);
                        }
                      } catch (e) {
                        setLoading(false);
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
