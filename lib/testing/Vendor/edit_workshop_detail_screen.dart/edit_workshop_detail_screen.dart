import 'dart:developer';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/testing/Vendor/edit_workshop_detail_screen.dart/edit_workshop_location_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditWorkshopDetailScreen extends StatefulWidget {
  const EditWorkshopDetailScreen({super.key});

  @override
  State<EditWorkshopDetailScreen> createState() =>
      _EditWorkshopDetailScreenState();
}

class _EditWorkshopDetailScreenState extends State<EditWorkshopDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVendorDetails();
  }

  Future<void> fetchVendorDetails() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot vendorDoc =
          await firestore.collection('vendors').doc(uid).get();

      if (vendorDoc.exists) {
        setState(() {
          _nameController.text = vendorDoc['workshop']['name'];
          _descController.text = vendorDoc['workshop']['desc'];
          _locationController.text =
              "${vendorDoc['workshop']['area']}, ${vendorDoc['workshop']['city']}";
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateVendorDetails() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('vendors').doc(uid).update({
        'workshop.name': _nameController.text,
        'workshop.desc': _descController.text,
        'workshop.area': _locationController.text.split(',')[0].trim(),
        'workshop.city': _locationController.text.split(',')[1].trim(),
      });
      Get.snackbar(
        "Success",
        "Workshop details updated successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: kWhiteColor,
      );
    } catch (e) {
      log(e.toString());
      Get.snackbar(
        "Error",
        "Failed to update workshop details",
        snackPosition: SnackPosition.TOP,
        backgroundColor: kDangerColor,
        colorText: kWhiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Edit Workshop Details',
          style: GoogleFonts.oxanium(color: kWhiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
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
                  labelText: 'Workshop Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Workshop Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Workshop Location (Area, City)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateVendorDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  '  Update Details ',
                  style: GoogleFonts.oxanium(color: kWhiteColor, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              //& sign
              Text(
                '&',
                style: GoogleFonts.oxanium(
                    color: kBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    Get.to(() => const UpdateWorkshopLocationScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Update Map Location',
                  style: GoogleFonts.oxanium(color: kWhiteColor, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
