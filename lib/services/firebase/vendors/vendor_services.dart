import 'dart:developer';

import 'package:car_fix_up/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';

class VendorServices {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<List<Vendor>> getAllVendors() async {
    try {
      final vendorsSnapshot = await _db.collection('vendors').get();
      return vendorsSnapshot.docs
          .map((doc) => Vendor.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> checkIsChatEmpty(List<Vendor> users) async {
    bool isChatEmpty = true;
    ChatController chatController = ChatController();
    for (Vendor user in users) {
      final result = await chatController.isChatCheckInit(user.uid);
      if (result) {
        isChatEmpty = false;
        break;
      }
    }
    return isChatEmpty;
  }

  Future<Vendor> getVendorByUid(String uid) async {
    try {
      final vendorSnapshot = await _db.collection('vendors').doc(uid).get();
      return Vendor.fromJson(vendorSnapshot.data()!);
    } catch (e) {
      print(e);
      throw Exception('Failed to get vendor');
    }
  }

  Future<List<String>> getAllVendorsUids() {
    try {
      final vendorsSnapshot = _db.collection('vendors').get();
      return vendorsSnapshot.then((value) {
        return value.docs.map((doc) => doc.id).toList();
      }).then((value) {
        return value;
      });
    } catch (e) {
      print(e);
      return [] as Future<List<String>>;
    }
  }
}
