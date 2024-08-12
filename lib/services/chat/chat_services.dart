import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  // CollectionReference groupCollection =
  //     FirebaseFirestore.instance.collection('groups');
  // DocumentReference groupDoc =
  //     FirebaseFirestore.instance.collection('groups').doc();

  // // Function to send a message
  // void sendMessage(String chatId, String senderUid, String message) {
  //   chatCollection.doc(chatId).collection('messages').add({
  //     'senderUid': senderUid,
  //     'message': message,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  void sendMessage(
      String chatId, String message, String recieverUid, String senderUid,
      {bool isMedia = false}) {
    log('chatId: $chatId');
    chatCollection.doc(chatId).collection('messages').add({
      'messageId': chatCollection.doc(chatId).collection('messages').doc().id,
      'recieverUid': recieverUid,
      'senderUid': senderUid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isMedia': isMedia,
      'isRead': false,
    });
  }

  Stream<QuerySnapshot> getChatMessagesStream(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }
  // Stream<QuerySnapshot> getChatMessagesStream(String chatId) async* {
  //   final docReference = chatCollection.doc(chatId);

  //   final docSnapshot = await docReference.get();

  //   if (docSnapshot.exists) {
  //     yield* docReference
  //         .collection('messages')
  //         .orderBy('timestamp')
  //         .snapshots();
  //   } else {
  //     yield* Stream.empty();
  //   }
  // }
  Stream<QuerySnapshot<Map<String, dynamic>>> lastMessage(
      String chatDocumentID) {
    return chatCollection
        .doc(chatDocumentID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  //Check for the Last Message sent by anyone to user that is unread to show in notification
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMsgStreamNotifier(
      String chatDocumentID) {
    return chatCollection
        .doc(chatDocumentID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> markChatAsRead(String chatID) async {
    final messagesCollection =
        chatCollection.doc(chatID).collection('messages');
    final unreadMessagesQuery =
        await messagesCollection.where('isRead', isEqualTo: false).get();
    final batchUpdate = FirebaseFirestore.instance.batch();
    for (final doc in unreadMessagesQuery.docs) {
      batchUpdate.update(doc.reference, {'isRead': true});
    }
    await batchUpdate.commit();
  }

  noOfNewMessages(String chatDocumentID) {
    //log('New message check chatDocumentID: $chatDocumentID');
    return chatCollection
        .doc(chatDocumentID)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .snapshots();
  }
}
