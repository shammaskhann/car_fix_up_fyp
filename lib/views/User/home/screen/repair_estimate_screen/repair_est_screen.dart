import 'dart:developer';
import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RepairEstScreen extends StatefulWidget {
  final Vendor vendor;
  const RepairEstScreen({super.key, required this.vendor});

  @override
  State<RepairEstScreen> createState() => _RepairEstScreenState();
}

class _RepairEstScreenState extends State<RepairEstScreen> {
  List<Map<String, dynamic>> _repairEstimates = [];
  List<Map<String, dynamic>> _selectedEstimates = [];

  @override
  void initState() {
    super.initState();
    fetchRepairEstimates(widget.vendor.uid);
  }

  Future<void> fetchRepairEstimates(String vendorUid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot vendorDoc =
          await firestore.collection('vendors').doc(vendorUid).get();

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

  List<double> calculateRepairEstimate() {
    double totalMinCost = 0;
    double totalMaxCost = 0;

    for (var estimate in _selectedEstimates) {
      double minCost = estimate['est_cost_min'] != null
          ? double.tryParse(estimate['est_cost_min'].toString()) ?? 0.0
          : 0.0;
      double maxCost = estimate['est_cost_max'] != null
          ? double.tryParse(estimate['est_cost_max'].toString()) ?? 0.0
          : 0.0;

      totalMinCost += minCost;
      totalMaxCost += maxCost;
    }
    return [totalMinCost, totalMaxCost];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Realtime Repair Estimates',
          style: GoogleFonts.oxanium(color: kWhiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, right: 16, left: 16, bottom: 0),
            child: Text(
              "Select the Issues",
              style: GoogleFonts.oxanium(
                  fontSize: 24.w,
                  color: kBlackColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _repairEstimates.isEmpty
              ? Expanded(
                  child: const Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _repairEstimates.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> estimate = _repairEstimates[index];
                      return CheckboxListTile(
                        checkColor: kPrimaryColor,
                        activeColor: kBlackColor,
                        title: Text(
                          estimate['title'],
                          style:
                              GoogleFonts.oxanium(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(estimate['desc'],
                            style: GoogleFonts.oxanium()),
                        value: _selectedEstimates.contains(estimate),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedEstimates.add(estimate);
                            } else {
                              _selectedEstimates.remove(estimate);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
            child: CustomButton(
              borderRadius: 10,
              text: "Get Estimate",
              onPressed: () async {
                if (_selectedEstimates.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please select at least one repair estimate",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: kDangerColor,
                    colorText: kWhiteColor,
                  );
                  return;
                }
                List<double> totalCost = calculateRepairEstimate();
                Get.toNamed(
                  RouteName.repairEstResult,
                  arguments: {
                    "vendorUid": widget.vendor.uid,
                    "selectedEstimates": _selectedEstimates,
                    "totalCost": totalCost,
                  },
                );
              },
              textColor: kWhiteColor,
              buttonColor: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
