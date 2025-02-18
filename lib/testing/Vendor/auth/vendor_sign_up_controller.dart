import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/services/firebase/auth/auth_services.dart';
import 'package:car_fix_up/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class VendorSignUpController extends GetxController {
  // Step 1: Vendor Info
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final placeHolderEmail = "".obs;
  final placeHolderName = "".obs;
  final placeHolderPassword = "".obs;
  final placeHolderPhone = "".obs;
  File? profileImage;
  Uint8List? profileImageBytes;
  RxBool isImageSelected = false.obs;

  void uploadImage() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        profileImage = File(value.path);
        profileImageBytes = profileImage!.readAsBytesSync();
        isImageSelected.value = true;
      }
    });
  }

  // Step 2: Workshop Info
  final workshopNameController = TextEditingController();
  final workshopDescController = TextEditingController();
  final workshopAreaController = TextEditingController();
  final workshopCityController = TextEditingController();
  final operationalTimeController = TextEditingController();
  final closeTimeController = TextEditingController();
  final placeHolderWorkshopName = "".obs;
  final placeHolderWorkshopDesc = "".obs;
  final placeHolderWorkshopArea = "".obs;
  final placeHolderWorkshopCity = "".obs;
  final placeHolderOperationalTime = "".obs;
  final placeHolderCloseTime = "".obs;

  // Step 3: Workshop Location
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // Step 4: Repair Estimates
  List<Map<String, dynamic>> repairEstimates = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  AuthServices authServices = AuthServices();

  Future<void> selectTime(BuildContext context,
      TextEditingController controller, RxString placeHolder) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = _formatTimeOfDay(picked);
      controller.text = formattedTime;
      placeHolder.value = '';
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('hh:mm a');
    return format.format(dt);
  }

  // ... existing code ...

  bool validateEstimates() {
    for (final estimate in repairEstimates) {
      if (estimate['title'].isEmpty ||
          estimate['desc'].isEmpty ||
          estimate['est_cost_min'] == 0 ||
          estimate['est_cost_max'] == 0) {
        Utils.getErrorSnackBar("All fields are required");
        return false;
      }
    }
    return true;
  }

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final result = await authServices.vendorSignUp(
          emailController.text,
          workshopNameController.text,
          passwordController.text,
          phoneController.text,
          workshopNameController.text,
          workshopDescController.text,
          workshopAreaController.text,
          workshopCityController.text,
          operationalTimeController.text,
          LatLng(latitude.value, longitude.value),
          closeTimeController.text,
          repairEstimates,
          profileImage);
      log(result.toString());
      if (result) {
        Utils.getSuccessSnackBar("Account created successfully");
        Get.offAllNamed(RouteName.login);
      }
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      Utils.getErrorSnackBar("An error occurred");
      isLoading.value = false;
    }
  }

  saveRepairEstimates() {
    final repairEstimates = this
        .repairEstimates
        .map((e) => {
              'title': e['title'],
              'desc': e['desc'],
              'est_cost_min': e['est_cost_min'],
              'est_cost_max': e['est_cost_max'],
            })
        .toList();
    log(repairEstimates.toString());
  }

  bool validateEmail(String value) {
    final isValid = GetUtils.isEmail(value);
    if (!isValid) {
      placeHolderEmail.value = "Please enter a valid email";
      return false;
    } else {
      placeHolderEmail.value = "";
      return true;
    }
  }

  bool validatePassword(String value) {
    final hasMinLength = value.length >= 8;
    final hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));

    if (!hasMinLength || !hasUpperCase || !hasNumber) {
      placeHolderPassword.value =
          'Password must be at least 8 characters, include an uppercase letter and a number';
      return false;
    } else {
      placeHolderPassword.value = "";
      return true;
    }
  }

  bool validatePhone(String value) {
    if (value.length != 11) {
      placeHolderPhone.value = "Please enter a valid contact number";
      return false;
    } else {
      placeHolderPhone.value = "";
      return true;
    }
  }

  bool validateTimeFormat(String value) {
    final timeFormat = RegExp(r'^\d{2}:\d{2} (AM|PM)$');
    if (!timeFormat.hasMatch(value)) {
      placeHolderOperationalTime.value = "Please enter a valid time format";
      return false;
    } else {
      placeHolderOperationalTime.value = "";
      return true;
    }
  }

  void addRepairEstimate() {
    repairEstimates.add({
      'title': '',
      'desc': '',
      'est_cost_min': 0,
      'est_cost_max': 0,
    });
  }

  void updateRepairEstimate(
      int index, String title, String desc, double minCost, double maxCost) {
    repairEstimates[index] = {
      'title': title,
      'desc': desc,
      'est_cost_min': minCost,
      'est_cost_max': maxCost,
    };
  }

  validateName(String value) {
    if (value.isEmpty) {
      placeHolderName.value = "Please enter your name";
      return false;
    } else {
      placeHolderName.value = "";
      return true;
    }
  }

  bool validateWorkshopName(String value) {
    if (value.isEmpty) {
      placeHolderWorkshopName.value = "Please enter your workshop name";
      return false;
    } else {
      placeHolderWorkshopName.value = "";
      return true;
    }
  }

  bool validateWorkshopDesc(String value) {
    if (value.isEmpty) {
      placeHolderWorkshopDesc.value = "Please enter your workshop description";
      return false;
    } else {
      placeHolderWorkshopDesc.value = "";
      return true;
    }
  }

  bool validateOperationalTime(String value) {
    final timeFormat = RegExp(r'^\d{2}:\d{2} (AM|PM)$');
    if (!timeFormat.hasMatch(value)) {
      placeHolderOperationalTime.value = "Please enter a valid time format";
      return false;
    } else {
      placeHolderOperationalTime.value = "";
      return true;
    }
  }

  bool validateCloseTime(String value) {
    if (!validateTimeFormat(value)) {
      placeHolderCloseTime.value = "Please enter a valid time format";
      return false;
    }

    final operationalTime = _parseTime(operationalTimeController.text);
    final closeTime = _parseTime(value);

    if (closeTime.isBefore(operationalTime)) {
      placeHolderCloseTime.value = "Close time must be after operational time";
      return false;
    } else {
      placeHolderCloseTime.value = "";
      return true;
    }
  }

  DateTime _parseTime(String time) {
    final format = RegExp(r'(\d{2}):(\d{2}) (AM|PM)');
    final match = format.firstMatch(time);
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!;

      return DateTime(
        0,
        1,
        1,
        period == 'PM' && hour != 12 ? hour + 12 : hour,
        minute,
      );
    }
    return DateTime(0);
  }

  bool validateWorkshopArea(String value) {
    if (value.isEmpty) {
      placeHolderWorkshopArea.value = "Please enter your workshop area";
      return false;
    } else {
      placeHolderWorkshopArea.value = "";
      return true;
    }
  }

  bool validateWorkshopCity(String value) {
    if (value.isEmpty) {
      placeHolderWorkshopCity.value = "Please enter your workshop city";
      return false;
    } else {
      placeHolderWorkshopCity.value = "";
      return true;
    }
  }
}
