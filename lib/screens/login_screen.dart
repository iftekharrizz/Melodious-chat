import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melodious_chat/buttons.dart';
import 'package:melodious_chat/constants.dart';
import 'package:melodious_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email, password;
  FirebaseAuth loggedInUser;
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoader,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kLoginTextFieldDecoration.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kLoginTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              UserButton(
                onTap: () async {
                  setState(() {
                    showLoader = true;
                  });
                  try {
                    final existingUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (existingUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showLoader = false;
                      });
                    }
                  } catch (e) {
                    setState(() {
                      showLoader = false;
                    });
                    if (e.code == 'user-not-found') {
                      print('no user found!');
                    } else if (e.code == 'wrong-password') {
                      print('password not correct! try again!!');
                    }
                  }
                },
                btnColor: kButtonAccentColor1,
                label: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
