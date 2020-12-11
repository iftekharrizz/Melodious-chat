import 'package:flutter/material.dart';
import 'package:melodious_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final textFieldController = TextEditingController();

  String msgText;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final User user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMesseges() async {
  //   final messages = await _fireStore.collection('messages').get();
  //   for (var message in messages.docs)
  //     {
  //       print(message.data());
  //     }
  // }

  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                messagesStream();
              }),
        ],
        title: Text('🎵 Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (value) {
                        msgText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _fireStore.collection('messages').add({
                        'author': loggedInUser.email,
                        'text': msgText,
                      });
                      textFieldController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kButtonAccentColor1,
            ),
          );
        }
        List<MessageBubble> messageWidgets = [];
        final messages = snapshot.data.docs;
        for (var message in messages) {
          final msg = message.data();
          final author = msg['author'];
          final text = msg['text'];
          final msgWidget = MessageBubble(text: text, author: author);
          messageWidgets.add(msgWidget);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text, author;

  MessageBubble({this.author, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            author,
            style: TextStyle(color: Colors.black45, fontSize: 15.0),
          ),
          Material(
            elevation: 5.0,
            color: kButtonAccentColor1,
            borderRadius: BorderRadius.circular(30.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
