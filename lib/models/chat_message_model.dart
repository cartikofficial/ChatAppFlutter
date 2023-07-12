import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String message;
  final String sender;
  final String time;
  const ChatMessageModel({
    required this.message,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> tojson() => {
        "Message": message,
        "Sender": sender,
        "Time": time,
      };

  factory ChatMessageModel.datasnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ChatMessageModel(
      message: data[""],
      sender: data[""],
      time: data[""],
    );
  }
}
