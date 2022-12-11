import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/models/messsage.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList = [];
  Future<void> sendMessage(
      {required String message, required String email}) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'message': message,
      'sender': email,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void getMessages() {
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) {
      messagesList.clear(); // * Mandatory
      print(event.docs);
      for (var doc in event.docs) {
        print('doc = $doc');
        messagesList.add(Message.fromMap(doc.data()));
        //messagesList.add(Message(message: doc['message'], sender: doc['sender']));
      }
      print('have been listened to');
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
