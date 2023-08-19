import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/registration.dart';
import 'package:flutter_chat/screens/welcome.dart';
import 'package:flutter_chat/screens/login.dart';
import 'package:flutter_chat/screens/chat.dart';

void main() => runApp(FlashChat());

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
