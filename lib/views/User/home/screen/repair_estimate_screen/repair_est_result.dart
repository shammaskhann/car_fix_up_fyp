import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RepairEstResultScreen extends StatelessWidget {
  final String vendorUid;
  final List<Map<String, dynamic>> selectedEstimates;
  final List<double> totalCost;

  const RepairEstResultScreen({
    Key? key,
    required this.vendorUid,
    required this.selectedEstimates,
    required this.totalCost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Repair Estimate Result',
          style: GoogleFonts.oxanium(color: kWhiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Repair Estimates:',
              style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedEstimates.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> estimate = selectedEstimates[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: kPrimaryColor,
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.oxanium(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          estimate['title'],
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Min Cost: Rs ${estimate['est_cost_min']}',
                              style: GoogleFonts.oxanium(),
                            ),
                            Text(
                              'Max Cost: Rs ${estimate['est_cost_max']}',
                              style: GoogleFonts.oxanium(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: kPrimaryColor, thickness: 2),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: kPrimaryColor, thickness: 2),
            Text(
              'Total Minimum Cost: Rs ${totalCost[0]} (Hatchback & Sedan)',
              style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Total Maximum Cost: Rs ${totalCost[1]} (4x4 & SUV & Luxury)',
              style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Obx(() => CustomButton(
                  text: "Schedule Visit",
                  isLoading: isLoading.value,
                  onPressed: () async {
                    isLoading.value = true;
                    VendorServices vendorServices = VendorServices();
                    var vendor = await vendorServices.getVendorByUid(vendorUid);

                    Get.toNamed(RouteName.scheduleAppoint, arguments: {
                      "vendor": vendor,
                      "isMobileRepair": false,
                      "loc": null,
                    });
                    isLoading.value = false;
                  },
                  borderRadius: 5,
                  textColor: kWhiteColor,
                  buttonColor: kPrimaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
