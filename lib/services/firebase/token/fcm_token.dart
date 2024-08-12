import 'dart:developer';

import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/services/local-storage/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class fcmToken {
  final auth = FirebaseAuth.instance;
  final fcm = FirebaseMessaging.instance;
  final _db = FirebaseFirestore.instance;
  UserController userController = Get.find<UserController>();

  void checkForRefreshToken(String token) async {
    try {
      String? currentToken = await fcm.getToken();
      if (currentToken != null) {
        if (currentToken != token) {
          log('saving new token in db');
          saveNewTokenInDb(currentToken);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveNewTokenInDb(String token) async {
    final user = auth.currentUser;
    await _db.collection('users').doc(user!.uid).update({
      'deviceToken': token,
    });
    LocalStorageService().saveDeviceToken(token);
    userController.deviceToken = token;
  }
}
