import 'dart:developer';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateRepairEstScreen extends StatefulWidget {
  const UpdateRepairEstScreen({super.key});

  @override
  State<UpdateRepairEstScreen> createState() => _UpdateRepairEstScreenState();
}

class _UpdateRepairEstScreenState extends State<UpdateRepairEstScreen> {
  List<Map<String, dynamic>> _repairEstimates = [];
  String? selectedVendorUid;
  final TextEditingController _minCostController = TextEditingController();
  final TextEditingController _maxCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  Future<void> fetchVendors() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot vendorsSnapshot =
          await firestore.collection('vendors').get();

      if (vendorsSnapshot.docs.isNotEmpty) {
        selectedVendorUid = vendorsSnapshot.docs.first.id;
        fetchRepairEstimates(selectedVendorUid!);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchRepairEstimates(String vendorUid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot vendorDoc =
          await firestore.collection('vendors').doc(vendorUid).get();

      if (vendorDoc.exists) {
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

  Future<void> updateRepairEstimate(String vendorUid, int index) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      _repairEstimates[index]['est_cost_min'] =
          int.parse(_minCostController.text);
      _repairEstimates[index]['est_cost_max'] =
          int.parse(_maxCostController.text);

      await firestore.collection('vendors').doc(vendorUid).update({
        'repair_estimates': _repairEstimates,
      });

      Get.snackbar('Success', 'Repair estimate updated successfully!');
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to update repair estimate.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Update Repair Estimates',
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
                return ListTile(
                  title: Text(
                    estimate['title'],
                    style: GoogleFonts.oxanium(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        estimate['desc'],
                        style: GoogleFonts.oxanium(),
                      ),
                      TextField(
                        controller: _minCostController
                          ..text = estimate['est_cost_min'].toString(),
                        decoration:
                            const InputDecoration(labelText: 'Min Cost'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: _maxCostController
                          ..text = estimate['est_cost_max'].toString(),
                        decoration:
                            const InputDecoration(labelText: 'Max Cost'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () =>
                            updateRepairEstimate(selectedVendorUid!, index),
                        child: const Text('Update Prices'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
