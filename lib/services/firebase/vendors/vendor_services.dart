import 'dart:developer';

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
      print(e);
      return [];
    }
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
}
