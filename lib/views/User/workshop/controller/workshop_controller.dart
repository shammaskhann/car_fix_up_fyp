import 'dart:convert';
import 'dart:developer';

import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:get/get.dart';

import '../../../../services/firebase/vendors/vendor_services.dart';

class WorkshopController extends GetxController {
  final VendorServices _vendorServices = VendorServices();
  List<Vendor> vendors = [];

  Future<List<Vendor>?> getAllWorkshop() async {
    try {
      vendors = await _vendorServices.getAllVendors();
      return vendors;
    } catch (e) {
      log(e.toString(), name: 'WorkshopController');
      return null;
    }
  }
}
