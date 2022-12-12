import 'package:flash_chat/components/show_alert_dialog.dart';
import 'package:flash_chat/cubits/chat_cubit/chat_cubit.dart';
import 'package:flash_chat/models/messsage.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<ChatCubit>(context).getMessages(); // * Trigger bloc
    print(
        'length didchanged : ${BlocProvider.of<ChatCubit>(context).messagesList.length}');
  }

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
            MessageStream(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                        //Mandatory async and await, without them the scrollController.position.maxScrollExtent scrolls down
                        // before new message added so it scroll to the latestbefore not the latest
                        onPressed: () async {
                          messageTextController.clear();
                          //Auto Scroll to the new message

                          BlocProvider.of<ChatCubit>(context).sendMessage(
                              message: messageText!,
                              email: loggedInUser!.email!);
                          setState(() {
                            scrollController.animateTo(
                              // 1.0
                              //0.0
                              scrollController.position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          });
                        },
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      // ! xxx BlocProvider.of<ChatCubit>(context).getMessages(); xxx trigger bloc -> infinite rebuild
      final messageList = BlocProvider.of<ChatCubit>(context).messagesList;
      print(
          'length: ${BlocProvider.of<ChatCubit>(context).messagesList.length}');
      return Expanded(
        //Error:must wrap it with Expanded --> Crash App
        child: ListView.builder(
          controller: scrollController, //Auto Scroll to the new message
          itemBuilder: (context, int index) {
            return BubbleMessage(
              message: messageList[index],
            );
          },
          itemCount: messageList.length,
        ),
      );
    });
  }
}

class BubbleMessage extends StatelessWidget {
  Message message;
  BubbleMessage({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: message.sender == loggedInUser!.email
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            message.sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: message.sender == loggedInUser!.email
                ? kBorderRadiusMe
                : kBorderRadiusNotMe,
            elevation: 5.0,
            color: message.sender == loggedInUser!.email
                ? Colors.lightBlueAccent
                : Colors.grey, //if Sender
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message.message,
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
