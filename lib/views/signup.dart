import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:melodious_chatapp/helper/buttons.dart';
import 'package:melodious_chatapp/helper/constants.dart';
import 'package:melodious_chatapp/helper/helperfunctions.dart';
import 'package:melodious_chatapp/helper/theme.dart';
import 'package:melodious_chatapp/services/auth.dart';
import 'package:melodious_chatapp/services/database.dart';
import 'package:melodious_chatapp/views/chatrooms.dart';
import 'package:melodious_chatapp/widget/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  static const String id = 'sign_up';

  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  singUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName":
                usernameEditingController.text.substring(0, 1).toUpperCase() +
                    usernameEditingController.text.substring(1).toLowerCase(),
            "userEmail": emailEditingController.text
          };
          print(usernameEditingController.text.substring(0, 1).toUpperCase() +
              usernameEditingController.text.substring(1).toLowerCase());

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text.substring(0, 1).toUpperCase() +
                  usernameEditingController.text.substring(1).toLowerCase());
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
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
                        height: 150.0,
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
                            TextStyle(fontFamily: 'Dancing', fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: simpleTextStyle(),
                            controller: usernameEditingController,
                            validator: (val) {
                              return val.isEmpty || val.length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            decoration: textFieldInputDecoration("username"),
                          ),
                          TextFormField(
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Enter correct email";
                            },
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password"),
                            controller: passwordEditingController,
                            validator: (val) {
                              return val.length < 6
                                  ? "Enter Password 6+ characters"
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    UserButton(
                      onTap: () {
                        singUp();
                      },
                      btnColor: kButtonAccentColor2,
                      label: 'Sign Up',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: simpleTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15,
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
    ;
  }
}
