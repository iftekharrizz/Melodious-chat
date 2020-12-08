import 'package:flutter/material.dart';
import 'package:melodious_chat/screens/welcome_screen.dart';
import 'package:melodious_chat/screens/login_screen.dart';
import 'package:melodious_chat/screens/registration_screen.dart';
import 'package:melodious_chat/screens/chat_screen.dart';

void main() => runApp(MelodiousChat());

class MelodiousChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          // ignore: deprecated_member_use
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}