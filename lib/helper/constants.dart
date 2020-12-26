import 'package:flutter/material.dart';

class Constants {
  static String myName = "";
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.white),
  border: OutlineInputBorder(),
  fillColor: kButtonAccentColor2,
  filled: true,
);

const kMessageContainerDecoration = BoxDecoration(
  //gradient: Gradient(),
  border: Border(
    top: BorderSide(color: Colors.white, width: 10),
  ),
);

const kHintTextFieldStyle = TextStyle(
  color: Colors.grey,
  fontStyle: FontStyle.italic,
);

const kButtonAccentColor1 = Color(0xffFF7477);
const kButtonAccentColor2 = Color(0xff2E2E20);

const kLoginTextFieldDecoration = InputDecoration(
  hintText: 'Enter your text',
  hintStyle: kHintTextFieldStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kButtonAccentColor1, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kButtonAccentColor1, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kRegisterTextFieldDecoration = InputDecoration(
  hintText: 'Enter your text',
  hintStyle: kHintTextFieldStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kButtonAccentColor2, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kButtonAccentColor2, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kMessageBubbleAuthorBorder = BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0));
const kMessageBubbleOthersBorder = BorderRadius.only(
    topRight: Radius.circular(30),
    bottomLeft: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0));
