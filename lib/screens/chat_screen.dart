import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Todo: spinner while waiting is overflowing up ->fix it
//Todo: automatically scrollDown to new message
final _auth = FirebaseAuth.instance; //to get current user
User? loggedInUser; //FirebaseUser depricated -> User

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextContoller =
      TextEditingController(); //TextField clear after sending
  final _firestore =
      FirebaseFirestore.instance; //XX Firestore.instance //to add data
  final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('timestamp')
      .snapshots(); //to get snapshot collection

  String? messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser!; //return currentuser if exist
    // currentUser() -> currentUser!
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser?.email);
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
                //_auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(chatStream: _chatStream),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextContoller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextContoller.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
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

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key? key,
    required Stream<QuerySnapshot<Object?>> chatStream,
  })  : _chatStream = chatStream,
        super(key: key);

  final Stream<QuerySnapshot<Object?>> _chatStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ), // CircularProgress Indicator
          ); // Center
        }
        return Expanded(
          //Error:must wrap it with Expanded --> Crash App
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              //print('zzzz${data['sender']}');
              return BubbleMessage(
                sender: data['sender'],
                text: data['text'],
                isMe: loggedInUser?.email == data['sender'],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class BubbleMessage extends StatelessWidget {
  final String sender;
  final String text;
  bool isMe;
  BubbleMessage({required this.sender, required this.text, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe ? kBorderRadiusMe : kBorderRadiusNotMe,
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.grey, //if Sender
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ), // TextStyle
              ), // Text
            ), // Padding
          ),
        ],
      ), // Material
    ); // Padding
  }
}
