import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;
  var placeHolderEmail = ''.obs;

  bool validateEmail(String value) {
    if (value.isEmpty) {
      placeHolderEmail.value = 'Email cannot be empty';
      return false;
    } else if (!GetUtils.isEmail(value)) {
      placeHolderEmail.value = 'Enter a valid email';
      return false;
    } else {
      placeHolderEmail.value = '';
      return true;
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if (validateEmail(emailController.text)) {
      isLoading.value = true;
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        Get.snackbar(
            'Success', 'Password reset email sent. Please check your inbox.',
            backgroundColor: Colors.green);
      } catch (e) {
        Get.snackbar('Error', e.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
