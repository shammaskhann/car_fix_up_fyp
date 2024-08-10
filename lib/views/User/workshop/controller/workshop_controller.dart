import 'dart:convert';
import 'dart:developer';

import 'package:car_fix_up/model/vendor.model.dart';
import 'package:car_fix_up/model/workshop.model.dart';
import 'package:get/get.dart';

import '../../../../services/firebase/vendors/vendor_services.dart';

class WorkshopController extends GetxController {
  final VendorServices _vendorServices = VendorServices();
  List<Vendor> vendors = [];

  Future<List<Vendor>?> getAllWorkshop() async {
    try {
      vendors = await _vendorServices.getAllVendors();
      // log(vendors[0].workshopReviews[0].toJson().toString());
      // final workshopList = vendors.map((vendor) => vendor.workshop).toList();
      // return workshopList;
      return vendors;
    } catch (e) {
      log(e.toString(), name: 'WorkshopController');
      return null;
    }
  }
}
