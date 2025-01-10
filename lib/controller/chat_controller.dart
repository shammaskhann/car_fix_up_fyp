//import 'dart:developer';
import 'dart:developer';
import 'dart:io';

import 'package:car_fix_up/model/Chat/Message.model.dart';
import 'package:car_fix_up/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatController {
  final auth = FirebaseAuth.instance;

  final ChatServices _chatServices = ChatServices();

  sendMessage(String recieverUid, String message) async {
    final user = auth.currentUser;

    String chatDocumentId = '${user!.uid}_$recieverUid';
    _chatServices.sendMessage(
      chatDocumentId,
      message,
      recieverUid,
      user.uid,
      isRead: false,
    );

    String chatDocumentId2 = '${recieverUid}_${user.uid}';
    _chatServices.sendMessage(
      chatDocumentId2,
      message,
      recieverUid,
      user.uid,
      isRead: true,
    );
  }

  // getMessages(String senderUid) {
  //   final user = auth.currentUser;
  //   String chatDocumentId = '${user!.uid}_${senderUid}';
  //   //log('Fetching Messages from Stream as chatDocumentId: $chatDocumentId');
  //   return _chatServices.getChatMessagesStream(chatDocumentId);
  // }

  Stream<List<Message>> getMessages(String senderUid) {
    final user = auth.currentUser;
    String chatDocumentId = '${user!.uid}_${senderUid}';
    return _chatServices
        .getChatMessagesStream(chatDocumentId)
        .map((QuerySnapshot query) {
      return query.docs.map((doc) {
        return Message.fromDocument(doc);
      }).toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> lastMessege(String senderUid) {
    final user = auth.currentUser;
    String chatDocumentId = '${user!.uid}_${senderUid}';
    //log('chatDocumentId: $chatDocumentId');
    return _chatServices.lastMessage(chatDocumentId);
  }

  markChatAsReadn(String senderUid) {
    final user = auth.currentUser;
    String chatDocumentId = '${senderUid}_${user!.uid}';
    //log('Marking As Seen Msg of chatDocumentId: $chatDocumentId');
    return _chatServices.markChatAsRead(chatDocumentId);
  }

  noOfNewMessage(String senderUid) {
    final user = auth.currentUser;
    String chatDocumentId = '${senderUid}_${user!.uid}';

    // String chatDocumentId = '${user!.uid}_${senderUid}';
    log('Check No Of New Messages chatDocumentId: $chatDocumentId',
        name: 'ChatController');
    //log('Check No Of New Messages chatDocumentId: $chatDocumentId');
    return _chatServices.noOfNewMessages(chatDocumentId);
  }

  //Media Upload
  uploadMedia(String senderUid, String receiverUid, ImageSource what) async {
    final ChatServices _chatServices = ChatServices();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String chatDocumentId = '${user!.uid}_${senderUid}';
    //log('chatDocumentId: $chatDocumentId');
    final chatId = chatDocumentId;
    String chatDocumentId2 = '${senderUid}_${user.uid}';
    //log('chatDocumentId2: $chatDocumentId2');
    final chatId2 = chatDocumentId2;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: what);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('chat_media')
          .child(chatId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageReference.putFile(file);
      final mediaUrl = await storageReference.getDownloadURL();
      _chatServices.sendMessage(
        chatId,
        mediaUrl,
        receiverUid,
        senderUid,
        isMedia: true,
      );
      _chatServices.sendMessage(
        chatId2,
        mediaUrl,
        receiverUid,
        senderUid,
        isMedia: true,
      );
    }
  }

  uploadVideo(String senderUid, String recieverUid, ImageSource what) async {
    ChatServices _chatServices = ChatServices();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String chatDocumentId = '${user!.uid}_${senderUid}';
    //log('chatDocumentId: $chatDocumentId');
    final chatId = chatDocumentId;
    String chatDocumentId2 = '${senderUid}_${user.uid}';
    //log('chatDocumentId2: $chatDocumentId2');
    final chatId2 = chatDocumentId2;
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: what);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('chat_media')
          .child(chatId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageReference.putFile(file);
      final mediaUrl = await storageReference.getDownloadURL();
      _chatServices.sendMessage(
        chatId,
        mediaUrl,
        recieverUid,
        senderUid,
        isMedia: true,
      );
      _chatServices.sendMessage(
        chatId2,
        mediaUrl,
        recieverUid,
        senderUid,
        isMedia: true,
      );
    }
  }

  Stream<bool> isChatInitiated(String senderUid) {
    final user = auth.currentUser;
    String chatDocumentId = '${user!.uid}_${senderUid}';
    return _chatServices.isChatInitiated(chatDocumentId);
  }
}
