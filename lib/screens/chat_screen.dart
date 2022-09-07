import 'package:flash_chat/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance; //to get current user
User? loggedInUser; //FirebaseUser depricated -> User
//Auto Scroll to the new message
final ScrollController scrollController = ScrollController();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController =
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
    final user = _auth.currentUser!; //return currentuser if exist
    // currentUser() -> currentUser!
    loggedInUser = user;
    print(loggedInUser?.email);
  }

  Future<void> signingOut(BuildContext context) async {
    await showAlertDialog(context,
        title: 'logOut', content: 'Are You sure?', defaultActionText: 'yes');
    await _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //leading: null,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await signingOut(context);
              }),
        ],
        title: const Text('⚡️Chat'),
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
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      //Auto Scroll to the new message
                      scrollController.animateTo(
                        // 1.0
                        //0.0
                        scrollController.position.maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                    child: const Text(
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
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ), // CircularProgress Indicator
            ),
          ); // Center
        }
        return Expanded(
          //Error:must wrap it with Expanded --> Crash App
          child: ListView(
            controller: scrollController, //Auto Scroll to the new message
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
  BubbleMessage(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe ? kBorderRadiusMe : kBorderRadiusNotMe,
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.grey, //if Sender
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: const TextStyle(
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
