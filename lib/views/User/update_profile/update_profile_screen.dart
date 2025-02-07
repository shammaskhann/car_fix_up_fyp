import 'dart:developer';

import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/local-storage/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  const UpdateProfileScreen(
      {required this.name,
      required this.email,
      required this.phone,
      super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isUpdatingProfile = false;
  bool _isUpdatingPassword = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _phoneController.text = widget.phone;
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    setState(() {
      _isUpdatingPassword = true;
    });

    User? user = _auth.currentUser;
    final _db = FirebaseFirestore.instance;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        await _auth.signOut();
        await _auth.signInWithEmailAndPassword(
            email: user.email!, password: newPassword);
        await _db.collection('users').doc(user.uid).update({
          'password': newPassword,
        });
        log("Password updated successfully");
        Get.snackbar("Success", "Password updated successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } on FirebaseAuthException catch (e) {
        log("Error: ${e.message}");
        Get.snackbar("Error", e.message!,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } finally {
        setState(() {
          _isUpdatingPassword = false;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    setState(() {
      _isUpdatingProfile = true;
    });

    User? user = _auth.currentUser;
    final _db = FirebaseFirestore.instance;
    if (user != null) {
      try {
        await _db.collection('users').doc(user.uid).update({
          'name': _nameController.text,
          'phone': _phoneController.text,
        });
        await LocalStorageService().saveName(_nameController.text);
        await LocalStorageService().saveContactNo(_phoneController.text);
        log("Profile updated successfully");
        Get.snackbar("Success", "Profile updated successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        log("Error: $e");
        Get.snackbar("Error", e.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } finally {
        setState(() {
          _isUpdatingProfile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Update Profile',
          style: GoogleFonts.oxanium(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: widget.email),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email cannot be changed'),
                    ),
                  );
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isUpdatingProfile ? null : updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: _isUpdatingProfile
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Update Details',
                        style: GoogleFonts.oxanium(
                            color: Colors.white, fontSize: 18),
                      ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isUpdatingPassword
                    ? null
                    : () {
                        if (_newPasswordController.text.length < 6) {
                          Get.snackbar("Error",
                              "Password should be at least 6 characters",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        } else {
                          updatePassword(_currentPasswordController.text,
                              _newPasswordController.text);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: _isUpdatingPassword
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Update Password',
                        style: GoogleFonts.oxanium(
                            color: Colors.white, fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
