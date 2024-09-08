import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/views/widgets/workshop_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Workshoplistselect extends StatelessWidget {
  final LatLng loc;
  const Workshoplistselect(
    this.loc, {
    super.key,
  });

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
            "Select Workshop to get Mobile Repair",
            style: GoogleFonts.oxanium(color: kWhiteColor),
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10),
        child: FutureBuilder<List<Vendor>>(
            future: vendorServices.getAllVendors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              if (snapshot.data == null) {
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
                return Expanded(
                  child: ListView.builder(
                    itemCount: vendors!.length,
                    itemBuilder: (context, index) {
                      return WorkshopTile(
                          vendor: vendors[index],
                          onTap: () => Get.toNamed(RouteName.scheduleAppoint,
                                  arguments: {
                                    "vendor": vendors[index],
                                    "isMobileRepair": true,
                                    "loc": loc
                                  }));
                    },
                  ),
                );
              }
              return Center(
                child: Text(
                    (snapshot.data == null) ? "No Workshop" : "Server Error"),
              );
            }),
      ),
    );
  }
}
