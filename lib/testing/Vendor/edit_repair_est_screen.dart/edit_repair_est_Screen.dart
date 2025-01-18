import 'dart:developer';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditRepairEstScreen extends StatefulWidget {
  const EditRepairEstScreen({super.key});

  @override
  State<EditRepairEstScreen> createState() => _EditRepairEstScreenState();
}

class _EditRepairEstScreenState extends State<EditRepairEstScreen> {
  List<Map<String, dynamic>> _repairEstimates = [];

  @override
  void initState() {
    super.initState();
    fetchRepairEstimates();
  }

  Future<void> fetchRepairEstimates() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot vendorDoc =
          await firestore.collection('vendors').doc(uid).get();

      if (vendorDoc.exists) {
        log(vendorDoc['repair_estimates'].toString());
        List<Map<String, dynamic>> repairEstimates =
            List<Map<String, dynamic>>.from(vendorDoc['repair_estimates']);
        setState(() {
          _repairEstimates = repairEstimates;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateRepairEstimates() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('vendors')
          .doc(uid)
          .update({'repair_estimates': _repairEstimates});
      Get.snackbar(
        "Success",
        "Repair estimates updated successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: kWhiteColor,
      );
    } catch (e) {
      log(e.toString());
      Get.snackbar(
        "Error",
        "Failed to update repair estimates",
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
          'Edit Repair Estimates',
          style: GoogleFonts.oxanium(color: kWhiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: _repairEstimates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _repairEstimates.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> estimate = _repairEstimates[index];
                TextEditingController titleController =
                    TextEditingController(text: estimate['title']);
                TextEditingController descController =
                    TextEditingController(text: estimate['desc']);
                TextEditingController minCostController = TextEditingController(
                    text: estimate['est_cost_min'].toString());
                TextEditingController maxCostController = TextEditingController(
                    text: estimate['est_cost_max'].toString());

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimate ${index + 1}',
                                style: GoogleFonts.oxanium(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _repairEstimates.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              estimate['title'] = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              estimate['desc'] = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: minCostController,
                            decoration: const InputDecoration(
                              labelText: 'Min Cost',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              estimate['est_cost_min'] = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: maxCostController,
                            decoration: const InputDecoration(
                              labelText: 'Max Cost',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              estimate['est_cost_max'] = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateRepairEstimates,
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.save, color: kWhiteColor),
      ),
    );
  }
}
