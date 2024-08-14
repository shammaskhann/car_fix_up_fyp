import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String recieverUid;
  final String senderUid;
  final String message;
  final Timestamp? timestamp;
  final bool isMedia;
  final bool isRead;

  Message({
    required this.messageId,
    required this.recieverUid,
    required this.senderUid,
    required this.message,
    required this.timestamp,
    required this.isMedia,
    required this.isRead,
  });

  // Factory method to create a Message from a Firestore document
  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      messageId: doc['messageId'],
      recieverUid: doc['recieverUid'],
      senderUid: doc['senderUid'],
      message: doc['message'],
      timestamp: doc['timestamp'] as Timestamp?,
      isMedia: doc['isMedia'],
      isRead: doc['isRead'],
    );
  }

  // Method to convert a Message to a Firestore document
  Map<String, dynamic> toDocument() {
    return {
      'messageId': messageId,
      'recieverUid': recieverUid,
      'senderUid': senderUid,
      'message': message,
      'timestamp': timestamp,
      'isMedia': isMedia,
      'isRead': isRead,
    };
  }
}
