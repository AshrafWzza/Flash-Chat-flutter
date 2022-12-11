import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String sender;
  final timestamp = FieldValue.serverTimestamp();

  Message({required this.message, required this.sender});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      sender: map['sender'] as String,
    );
  }
}
