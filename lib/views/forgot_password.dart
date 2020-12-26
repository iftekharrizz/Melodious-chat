import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melodious_chatapp/services/auth.dart';
import 'package:melodious_chatapp/helper/buttons.dart';
import 'package:melodious_chatapp/helper/constants.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey formKey;
  TextEditingController emailEditingController = TextEditingController();

  // AuthService _authService = new AuthService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String emailStatus = "";

  Future<void> sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('assets/images/logo.png'),
                height: 165.0,
              ),
            ),
            Center(
              child: TyperAnimatedTextKit(
                duration: Duration(milliseconds: 3500),
                isRepeatingAnimation: true,
                onTap: () {},
                text: ["Listen to the melody of conversations..."],
                textAlign: TextAlign.center,
                textStyle: TextStyle(fontFamily: 'Dancing', fontSize: 20),
              ),
            ),
            SizedBox(height: 40),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Please Enter Correct Email";
                    },
                    controller: emailEditingController,
                    //style: kte,
                    keyboardType: TextInputType.emailAddress,
                    //decoration: textFieldInputDecoration("email"),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(emailStatus),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
            SizedBox(
              height: 16,
            ),
            UserButton(
              onTap: () async {
                try {
                  await _firebaseAuth.sendPasswordResetEmail(
                      email: emailEditingController.text);
                } catch (e) {
                  if (e != null) emailStatus = "User not found!";
                  setState(() {});
                  // emailStatus = "";
                }
                if (emailStatus == null) {
                  emailStatus = "Reset email sent";
                  setState(() {});
                  emailStatus = "";
                }
              },
              btnColor: kButtonAccentColor1,
              label: 'Reset password',
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
