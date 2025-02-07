import 'dart:developer';

import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/resources/constatnt.dart';
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

  void checkForRefreshToken() async {
    try {
      String? currentToken = await fcm.getToken();
      if (currentToken != null) {
        log('Current Token: $currentToken');
        saveNewTokenInDb(currentToken);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveNewTokenInDb(String token) async {
    log('saving new token in db');
    await copyVendorDocument(
        'Nrgn5cXIwxRLxMBebzogNMpGnda4', '0S42DmfJcLOJrVCXwoUudyizvOv1');
    final user = auth.currentUser;
    log('User: ${user!.uid}');
    final UserType userType = userController.userType;
    if (userType == UserType.user) {
      log('saving new token in user db USER TYPE');
      await _db.collection('users').doc(user!.uid).update({
        'deviceToken': token,
      });
    } else {
      log('saving new token in vendor db VENDOR TYPE');
      await _db.collection('vendors').doc(user!.uid).update({
        'deviceToken': token,
      });
    }
    LocalStorageService().saveDeviceToken(token);
    userController.deviceToken = token;
  }

  Future<void> copyVendorDocument(
      String sourceVendorId, String destinationVendorId) async {
    try {
      // Get the source vendor document
      DocumentSnapshot sourceDoc =
          await _db.collection('vendors').doc(sourceVendorId).get();

      if (sourceDoc.exists) {
        // Copy the data to the destination vendor document
        await _db
            .collection('vendors')
            .doc(destinationVendorId)
            .set(sourceDoc.data() as Map<String, dynamic>);
        log('Document copied successfully from $sourceVendorId to $destinationVendorId');
      } else {
        log('Source document does not exist');
      }
    } catch (e) {
      log('Error copying document: $e');
    }
  }
}
