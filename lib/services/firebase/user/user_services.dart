import 'dart:developer';

import 'package:car_fix_up/controller/chat_controller.dart';
import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/model/User/user.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/local-storage/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserServices extends GetxController {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserData() async {
    UserController userController = Get.find<UserController>();
    final user = auth.currentUser;
    if (userController.userType == UserType.user) {
      final userData = await _db.collection('users').doc(user!.uid).get();
      log('User Data: $userData');
      return userData;
    }
    if (userController.userType == UserType.vendor) {
      final userData = await _db.collection('vendors').doc(user!.uid).get();
      log('Vendor Data: $userData');
      return userData;
    }
    throw Exception('User type not recognized');
  }

  Future getUserDataById(String uid) async {
    UserController userController = Get.find<UserController>();
    // //check if the uesrType or user Controller is not Initialized fetch from LocalStorage
    // if (userController.userType == null) {
    //   LocalStorageService().getUserType().then((value) {
    //     userController.userType = (value == "UserType.user" || value == "user")
    //         ? UserType.user
    //         : (value == "UserType.vendor")
    //             ? UserType.vendor
    //             : UserType.user;
    //   });
    // }
    log('User Type: ${userController.userType}');
    if (userController.userType == UserType.user) {
      final userData = await _db.collection('vendors').doc(uid).get();
      log('Vendor Data: $userData');
      return userData;
    }
    if (userController.userType == UserType.vendor) {
      final userData = await _db.collection('users').doc(uid).get();
      log('User Data: $userData');
      return userData;
    }
    throw Exception('User type not recognized');
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final usersSnapshot = await _db.collection('users').get();
      return usersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> checkIsChatEmpty(List<UserModel> users) async {
    bool isChatEmpty = true;
    ChatController chatController = ChatController();
    for (UserModel user in users) {
      final result = await chatController.isChatCheckInit(user.uid);
      if (result) {
        isChatEmpty = false;
        break;
      }
    }
    return isChatEmpty;
  }

  Future<String> getUserDeviceTokenByUid(String uid) async {
    try {
      final user = await _db.collection('users').doc(uid).get();
      return user.data()!['deviceToken'];
    } catch (e) {
      print(e);
      return '';
    }
  }
}
