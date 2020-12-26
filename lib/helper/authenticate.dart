import 'package:melodious_chatapp/views/signin.dart';
import 'package:melodious_chatapp/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  bool firstView;

  Authenticate(this.firstView);

  @override
  _AuthenticateState createState() => _AuthenticateState(firstView: firstView);
}

class _AuthenticateState extends State<Authenticate> {
  bool firstView;

  _AuthenticateState({this.firstView});

  void toggleView() {
    setState(() {
      firstView = !firstView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstView) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
