import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:melodious_chatapp/helper/buttons.dart';
import 'package:melodious_chatapp/helper/constants.dart';
import 'package:melodious_chatapp/helper/helperfunctions.dart';
import 'package:melodious_chatapp/helper/theme.dart';
import 'package:melodious_chatapp/services/auth.dart';
import 'package:melodious_chatapp/services/database.dart';
import 'package:melodious_chatapp/views/chatrooms.dart';
import 'package:melodious_chatapp/views/forgot_password.dart';
import 'package:melodious_chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  static const String id = 'sign_in';

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SafeArea(
              child: Padding(
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
                        textStyle:
                            TextStyle(fontFamily: 'Dancing', fontSize: 20),
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
                            style: simpleTextStyle(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Enter Password 6+ characters";
                            },
                            style: simpleTextStyle(),
                            controller: passwordEditingController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: Text(
                                "Forgot Password?",
                                style: simpleTextStyle(),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    UserButton(
                      onTap: () {
                        signIn();
                      },
                      btnColor: kButtonAccentColor1,
                      label: 'Sign In',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: simpleTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
