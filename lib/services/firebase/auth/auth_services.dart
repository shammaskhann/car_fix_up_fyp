import 'dart:developer';
import 'dart:io';

import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserController userController = Get.find<UserController>();

  // ignore: non_constant_identifier_names
  Future<bool> Login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      AuthException.authExceptionToast(e.code);
      return false;
    }
  }

  Future<bool> vendorSignUp(
      String email,
      String name,
      String password,
      String phone,
      String workshopName,
      String workshopDesc,
      String workshopArea,
      String workshopCity,
      String operationalTime,
      LatLng loc,
      String closeTime,
      List<Map<String, dynamic>> repairEstimates,
      File? profileImage) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      log('Device Token: $deviceToken'); // This is the device token that will be used to send notifications to the user (if needed
      log('User UID: ${userCredential.user!.uid}');
      log('User Email: $email');
      log('User Password: $password');
      log('User Phone: $phone');
      log('User Name: $name');
      log('Workshop Name: $workshopName');
      log('Workshop Description: $workshopDesc');
      log('Workshop Area: $workshopArea');
      log('Workshop City: $workshopCity');
      log('Operational Time: $operationalTime');
      log('Close Time: $closeTime');

      String imageUrl =
          'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg';
      if (profileImage != null) {
        imageUrl = await uploadImage(profileImage, userCredential.user!.uid);
      }

      await _db.collection('vendors').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'uid': userCredential.user!.uid,
        'deviceToken': deviceToken,
        'workshop': {
          'area': workshopArea,
          'city': workshopCity,
          'closeTime': closeTime,
          'operationalTime': operationalTime,
          'desc': workshopDesc,
          'id': userCredential.user!.uid,
          'name': workshopName,
          'imageUrl': imageUrl,
          'loc': {'lat': loc.latitude, 'lng': loc.longitude},
        },
        'repair_estimates': repairEstimates,
        'reviews': [],
        'userType': 'vendor',
      });

      return true;
    } on FirebaseAuthException catch (e) {
      AuthException.authExceptionToast(e.code);
      return false;
    }
  }

  Future<String> uploadImage(File imageFile, String uid) async {
    try {
      final Reference storageRef =
          _storage.ref().child('vendors').child(uid).child('workshop.jpg');
      var url = storageRef.getDownloadURL();
      await storageRef.putFile(imageFile);
      return url;
    } catch (e) {
      log(e.toString());
      return 'https://blog.bayiq.com/hubfs/shutterstock_138252137.jpg';
    }
  }

  // ignore: non_constant_identifier_names
  Future<bool> SignUp(
      String name, String email, String password, String phone) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      log('Device Token: $deviceToken'); // This is the device token that will be used to send notifications to the user (if needed
      log('User UID: ${userCredential.user!.uid}');
      log('User Email: $email');
      log('User Password: $password');
      log('User Phone: $phone');
      log('User Name: $name');
      String userType = (userController.userType == UserType.user)
          ? 'user'
          : (userController.userType == UserType.vendor)
              ? 'vendor'
              : 'user';

      if (userType == 'user') {
        await _db.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'uid': userCredential.user!.uid,
          'deviceToken': deviceToken,
          'userType': userType,
        });
      }
      if (userType == 'vendor') {
        // await _db.collection('vendors').doc(userCredential.user!.uid).set({
        //   'name': name,
        //   'email': email,
        //   'password': password,
        //   'phone': phone,
        //   'uid': userCredential.user!.uid,
        //   'deviceToken': deviceToken,
        //   'userType': userType,
        // });
        throw UnimplementedError();
      }
      return true;
    } on FirebaseAuthException catch (e) {
      AuthException.authExceptionToast(e.code);
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      AuthException.authExceptionToast(e.code);
      return false;
    }
  }
}

class AuthException {
  static void authExceptionToast(String error) {
    log('Error: $error');
    String errorMessage = "An Error Occured";
    switch (error) {
      case 'invalid-email':
        errorMessage = 'Invalid email address';
        break;
      case 'user-not-found':
        errorMessage = 'User not found';
        break;
      case 'invalid-credential':
        errorMessage = 'Incorrect email or password';
      case 'wrong-password':
        errorMessage = 'Incorrect password';
        break;
      case 'email-already-in-use':
        errorMessage = 'Email is already in use';
        break;
      case 'weak-password':
        errorMessage = 'Weak password';
        break;
      default:
        errorMessage = error.toString();
        break;
    }
    Utils.getErrorSnackBar(errorMessage);
  }
}
