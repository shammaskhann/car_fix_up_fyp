import 'dart:developer';

import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:car_fix_up/views/widgets/workshop_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkshopListForLiveDiagnostic extends StatelessWidget {
  const WorkshopListForLiveDiagnostic({super.key});

  @override
  Widget build(BuildContext context) {
    VendorServices vendorServices = VendorServices();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kBlackColor,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhiteColor,
              )),
          title: Text(
            "Select Workshop for Live Diagnostic",
            style: GoogleFonts.oxanium(color: kWhiteColor),
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Vendor>>(
                future: vendorServices.getAllVendors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Workshop Found",
                        style: GoogleFonts.oxanium(
                          color: kPrimaryColor,
                          fontSize: 0.06.sw,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Vendor>? vendors = snapshot.data;

                    return ListView.builder(
                      itemCount: vendors!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: WorkshopTile(
                            vendor: vendors[index],
                            onTap: () async {
                              log("Device Token : ${vendors[index].deviceToken}");
                              // Send notification to the selected workshop
                              await PushNotification.sendNotification(
                                  vendors[index].deviceToken,
                                  "Live Diagnostic Call Incoming",
                                  "A Customer is seeking a Live Diagnostic on Video Call",
                                  {
                                    "notification_type": "CALL_NOTIFICATION",
                                    "callID": vendors[index].uid,
                                    "userID": "101",
                                  });

                              // Navigate to the video call screen with the workshop UID as the room number
                              Get.toNamed(RouteName.videoCall,
                                  arguments: vendors[index].uid);
                            },
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      "Server Error",
                      style: GoogleFonts.oxanium(
                        color: kPrimaryColor,
                        fontSize: 0.06.sw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
