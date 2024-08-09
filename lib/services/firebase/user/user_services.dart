import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserServices extends GetxController {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future getUserData() async {
    final user = auth.currentUser;
    final userData = await _db.collection('users').doc(user!.uid).get();
    log('User Data: ${userData.data()}');
    return userData;
  }
}
