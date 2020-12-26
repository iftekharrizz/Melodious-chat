import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:melodious_chatapp/helper/constants.dart';
import 'package:melodious_chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId, userName;

  Chat({this.chatRoomId, this.userName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  Firestore _firestore = Firestore.instance;
  TextEditingController messageEditingController = new TextEditingController();
  bool isinActive = true;
  final melody = AssetsAudioPlayer();

  //ScrollController _scrollController = new ScrollController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                //controller: _scrollController,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    text: snapshot.data.documents[index].data["message"],
                    isMe: Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  Widget chatttMessages() {
    String chatRoomId = widget.chatRoomId;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("chatRoom")
          .document(chatRoomId)
          .collection("chats")
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kButtonAccentColor1,
            ),
          );
        }
        List<MessageBubble> messageWidgets = [];
        final messages = snapshot.data.documents;
        for (var message in messages) {
          final messageData = message.data;
          final author = messageData['sendBy'];
          final text = messageData['message'];

          // print(text);
          // print("   sent by   $author");
          //final currentUser = loggedInUser.email;
          final messageDataWidget =
          MessageBubble(text: text, isMe: Constants.myName == author);
          messageWidgets.add(messageDataWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            melody.stop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          IconButton(
              icon: isinActive ? Icon(Icons.play_arrow) : Icon(Icons.pause),
              onPressed: () {
                print('the button is pressed');
                isinActive
                    ? melody.open(Audio(
                  'assets/audios/track3.mp3',
                ))
                    : melody.stop();
                if (isinActive == true) {
                  isinActive = false;
                  setState(() {});
                } else {
                  isinActive = true;
                  setState(() {});
                }
              }),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: kButtonAccentColor1,
                    //color: (counter%2 == 0)? (){ return kButtonAccentColor1;} (): kButtonAccentColor2,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    widget.userName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(widget.userName),
            ],
          ),
        ),
        backgroundColor: kButtonAccentColor2,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: chatMessages()),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: messageEditingController,
                      decoration: kRegisterTextFieldDecoration,
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                        onPressed: () {
                          addMessage();
                        },
                        child: Icon(
                          Icons.send,
                          color: kButtonAccentColor2,
                          size: 35,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  MessageBubble({this.text, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 5.0,
            color: isMe ? kButtonAccentColor1 : kButtonAccentColor2,
            borderRadius:
                isMe ? kMessageBubbleAuthorBorder : kMessageBubbleOthersBorder,
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
