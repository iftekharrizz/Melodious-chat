import 'package:flutter/material.dart';
import 'package:melodious_chat/constants.dart';
import 'package:melodious_chat/screens/login_screen.dart';
import 'package:melodious_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../buttons.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/logo.png'),
                height: 130.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Melodious',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffFF7477),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Chat',
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff2E2E20)),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: TyperAnimatedTextKit(
                duration: Duration(milliseconds: 3500),
                isRepeatingAnimation: true,
                onTap: () {},
                text: ["Listen to the melody of conversations..."],
                textAlign: TextAlign.center,
                textStyle: TextStyle(fontFamily: 'DancingScript', fontSize: 20),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            UserButton(
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              btnColor: kButtonAccentColor1,
              label: 'Log In',
            ),
            UserButton(
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              btnColor: kButtonAccentColor2,
              label: 'Register ',
            ),
          ],
        ),
      ),
    );
  }
}

