import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String type;
  final bool isSeen;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.type = 'text',
    this.isSeen = false,
  });

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "senderId": senderId,
    "receiverId": receiverId,
    "message": message,
    "timestamp": timestamp,
    "type": type,
    "isSeen": isSeen,
  };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    messageId: json["messageId"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    message: json["message"],
    timestamp: json["timestamp"],
    type: json["type"],
    isSeen: json["isSeen"] ?? false,
  );
}
