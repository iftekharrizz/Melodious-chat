import 'package:flutter/cupertino.dart';
import 'package:melodious_chatapp/helper/authenticate.dart';
import 'package:melodious_chatapp/helper/constants.dart';
import 'package:melodious_chatapp/helper/helperfunctions.dart';
import 'package:melodious_chatapp/helper/theme.dart';
import 'package:melodious_chatapp/services/auth.dart';
import 'package:melodious_chatapp/services/database.dart';
import 'package:melodious_chatapp/views/chat.dart';
import 'package:melodious_chatapp/views/search.dart';
import 'package:flutter/material.dart';
import 'package:melodious_chatapp/views/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

int counter;

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                    counter: counter++,
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
    counter = 2;
  }

  String loggedInUserName;

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        loggedInUserName = Constants.myName.toUpperCase();
        //print("we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to EXIT the App or Log out?'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () {
                    AuthService().signOut();
                    HelperFunctions.deleteDataPref();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()));
                  },
                  child: Text(
                    "Log out!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 26,
                  width: 20,
                ),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text(
                    "EXIT",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  //SharedPreferences _preferences = await  SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kButtonAccentColor1,
          title: Text(
            "$loggedInUserName's Chat!",
            style: TextStyle(
              fontFamily: 'OverpassRegular',
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                AuthService().signOut();
                HelperFunctions.deleteDataPref();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
                //HelperFunctions.saveUserLoggedInSharedPreference(false);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ),
        body: Container(
          child: chatRoomsList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          },
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final int counter;

  ChatRoomsTile({this.userName, @required this.chatRoomId, this.counter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                      userName: userName,
                    )));
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: (counter % 2 == 0)
                          ? () {
                              return kButtonAccentColor1;
                            }()
                          : kButtonAccentColor2,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      userName.substring(0, 1).toUpperCase(),
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
                  width: 22,
                ),
                Text(
                  userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1),
            child: Divider(
              color: (counter % 2 == 0)
                  ? () {
                      return kButtonAccentColor2;
                    }()
                  : kButtonAccentColor1,
              thickness: 0.5,
              height: 0,
              indent: 15,
              endIndent: 15,
            ),
          )
        ],
      ),
    );
  }
}
