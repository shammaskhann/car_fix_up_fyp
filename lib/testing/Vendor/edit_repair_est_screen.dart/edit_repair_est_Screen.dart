import 'dart:developer';
import 'package:car_fix_up/resources/constatnt.dart';
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
  final _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState!.validate()) {
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
  }

  void addNewEstimate() {
    setState(() {
      _repairEstimates.add({
        'title': '',
        'desc': '',
        'est_cost_min': 0,
        'est_cost_max': 0,
      });
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kWhiteColor),
            onPressed: addNewEstimate,
          ),
        ],
      ),
      body: _repairEstimates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView.builder(
                itemCount: _repairEstimates.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> estimate = _repairEstimates[index];
                  TextEditingController titleController =
                      TextEditingController(text: estimate['title']);
                  TextEditingController descController =
                      TextEditingController(text: estimate['desc']);
                  TextEditingController minCostController =
                      TextEditingController(
                          text: estimate['est_cost_min'].toString());
                  TextEditingController maxCostController =
                      TextEditingController(
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
                            TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                estimate['title'] = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: descController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                estimate['desc'] = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: minCostController,
                              decoration: const InputDecoration(
                                labelText: 'Min Cost',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                estimate['est_cost_min'] = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a minimum cost';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) >
                                    double.parse(maxCostController.text)) {
                                  return 'Min cost cannot be greater than max cost';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: maxCostController,
                              decoration: const InputDecoration(
                                labelText: 'Max Cost',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                estimate['est_cost_max'] = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a maximum cost';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) <
                                    double.parse(minCostController.text)) {
                                  return 'Max cost cannot be less than min cost';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateRepairEstimates,
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.save, color: kWhiteColor),
      ),
    );
  }
}
