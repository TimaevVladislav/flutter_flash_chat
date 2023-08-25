import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/registration.dart';
import 'package:flutter_chat/screens/welcome.dart';
import 'package:flutter_chat/screens/login.dart';
import 'package:flutter_chat/screens/chat.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyAQBw57Vy54frVZ1eUS2vxNQsecDoqWH4I", appId: "1:755012531996:android:ffdc29be0ad02655c0acd9", messagingSenderId: "755012531996", projectId: "flutter-chat-b2331"));
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: WelcomeScreen.route, routes: {
      WelcomeScreen.route: (context) => WelcomeScreen(),
      RegistrationScreen.route: (context) => RegistrationScreen(),
      LoginScreen.route: (context) => LoginScreen(),
      ChatScreen.route: (context) => ChatScreen()
    });
  }
}
