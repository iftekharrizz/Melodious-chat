import 'package:melodious_chatapp/helper/authenticate.dart';
import 'package:melodious_chatapp/helper/helperfunctions.dart';
import 'package:melodious_chatapp/views/chatrooms.dart';
import 'package:flutter/material.dart';
import 'package:melodious_chatapp/views/signin.dart';
import 'package:melodious_chatapp/views/signup.dart';
import 'package:melodious_chatapp/views/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xffFF7477),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn ? ChatRoom() : WelcomeScreen()
          : Container(
              child: Center(
                child: WelcomeScreen(),
              ),
            ),
      routes: {
        SignIn.id: (context) => SignIn(),
        SignUp.id: (context) => SignUp(),
      },
    );
  }
}
