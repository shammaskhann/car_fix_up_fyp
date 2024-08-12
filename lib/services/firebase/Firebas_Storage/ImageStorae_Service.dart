import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudImageServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadImageToFirebaseStorage(File imageFile, String uid) async {
    final Reference storageRef =
        _storage.ref().child('avatars').child(uid).child('avatar.jpg');
    var url = storageRef.getDownloadURL();
    db.collection('users').doc(uid).update({'avatar': url});
    await storageRef.putFile(imageFile);
  }

  Future getImageFromFireBaseStorage(String uid) async {
    final Reference storageRef =
        _storage.ref().child('avatars').child(uid).child('avatar.jpg');
    log('storageRef: $storageRef.getDownloadURL()');
    return await storageRef.getDownloadURL();
  }
}