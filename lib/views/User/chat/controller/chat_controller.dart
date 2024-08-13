import 'package:car_fix_up/controller/chat_controller.dart';
import 'package:car_fix_up/model/Chat/Message.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/services/firebase/user/user_services.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatViewController extends GetxController {
  VendorServices vendorServices = VendorServices();
  ChatController chatController = ChatController();
  UserServices userServices = UserServices();
  // Future<Vendor> getVendorByUid(String uid) async {
  //   try {
  //     return await vendorServices.getVendorByUid(uid);
  //   } catch (e) {
  //     throw Exception('Failed to get vendor');
  //   }
  // }

  Future getChatUserInfo(String uid) async {
    try {
      return await userServices.getUserDataById(uid);
    } catch (e) {
      throw Exception('Failed to get vendor');
    }
  }

  Stream<List<Message>>? getMessages(String senderUid) {
    return chatController.getMessages(senderUid);
  }

  void sendMessage(
      String recieverUid, TextEditingController messageController) {
    chatController.sendMessage(recieverUid, messageController.text);
  }

  //mark message as read
  void markMessageAsRead(String senderUid) {
    chatController.markChatAsReadn(senderUid);
  }

  void sendNotification(String recieverDeviceToken, String title, String body,
      String recieverUid) {
    PushNotification.sendNotification(recieverDeviceToken, title, body, {
      'click_action': 'CLICK_NOTIFICATION',
      'type': 'chat',
      'uid': recieverUid
    });
  }
}
