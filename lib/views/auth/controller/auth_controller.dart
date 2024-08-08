import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final placeHolderEmail = "".obs;
  final placeHolderPassword = "".obs;
  final rememberMe = true.obs;

  Future<String> login() async {
    if (emailController.text.isEmpty) {
      placeHolderEmail.value = "Email is required";
      return "Email is required";
    }
    if (passwordController.text.isEmpty) {
      placeHolderPassword.value = "Password is required";
      return "Password is required";
    }
    return "Success";
  }

  void validateEmail(String value) {
    final isValid = GetUtils.isEmail(value);
    if (!isValid) {
      placeHolderEmail.value = "Please enter a valid email";
    } else {
      placeHolderEmail.value = "";
    }
  }

  void validatePassword(String value) {
    final hasMinLength = value.length >= 8;
    final hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));

    if (!hasMinLength || !hasUpperCase || !hasNumber) {
      placeHolderPassword.value =
          'Password must be at least 8 characters, include an uppercase letter and a number';
    } else {
      placeHolderPassword.value = "";
    }
  }
}
