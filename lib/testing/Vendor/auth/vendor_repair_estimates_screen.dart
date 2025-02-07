import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RepairEstimatesScreen extends StatelessWidget {
  final VendorSignUpController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Vendor Signup - Step 4',
          style: GoogleFonts.oxanium(color: kWhiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kWhiteColor),
            onPressed: controller.addRepairEstimate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(
              () => controller.repairEstimates.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 150.h),
                        Center(
                          child: Text(
                            "No Repair Estimates Found",
                            style: GoogleFonts.oxanium(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: kBlackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 150.h,
                        ),
                      ],
                    )
                  : Form(
                      key: _formKey,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.repairEstimates.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> estimate =
                              controller.repairEstimates[index];
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

                          // Placeholder for the repair estimates RxString
                          RxString titleError = ''.obs;
                          RxString descError = ''.obs;
                          RxString minCostError = ''.obs;
                          RxString maxCostError = ''.obs;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            controller.repairEstimates
                                                .removeAt(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    Obx(
                                      () => TextFormField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          labelText: 'Title',
                                          border: OutlineInputBorder(),
                                          errorText: titleError.value.isEmpty
                                              ? null
                                              : titleError.value,
                                        ),
                                        onChanged: (value) {
                                          estimate['title'] = value;
                                          if (value.isEmpty) {
                                            titleError.value =
                                                'Please enter a title';
                                          } else {
                                            titleError.value = '';
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a title';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(
                                      () => TextFormField(
                                        controller: descController,
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          border: OutlineInputBorder(),
                                          errorText: descError.value.isEmpty
                                              ? null
                                              : descError.value,
                                        ),
                                        onChanged: (value) {
                                          estimate['desc'] = value;
                                          if (value.isEmpty) {
                                            descError.value =
                                                'Please enter a description';
                                          } else {
                                            descError.value = '';
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a description';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(
                                      () => TextFormField(
                                        controller: minCostController,
                                        decoration: InputDecoration(
                                          labelText: 'Min Cost',
                                          border: OutlineInputBorder(),
                                          errorText: minCostError.value.isEmpty
                                              ? null
                                              : minCostError.value,
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          estimate['est_cost_min'] = value;
                                          if (value.isEmpty) {
                                            minCostError.value =
                                                'Please enter a minimum cost';
                                          } else if (double.tryParse(value) ==
                                              null) {
                                            minCostError.value =
                                                'Please enter a valid number';
                                          } else if (double.parse(value) >
                                              double.parse(
                                                  maxCostController.text)) {
                                            minCostError.value =
                                                'Min cost cannot be greater than max cost';
                                          } else {
                                            minCostError.value = '';
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a minimum cost';
                                          }
                                          if (double.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          }
                                          if (double.parse(value) >
                                              double.parse(
                                                  maxCostController.text)) {
                                            return 'Min cost cannot be greater than max cost';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(
                                      () => TextFormField(
                                        controller: maxCostController,
                                        decoration: InputDecoration(
                                          labelText: 'Max Cost',
                                          border: OutlineInputBorder(),
                                          errorText: maxCostError.value.isEmpty
                                              ? null
                                              : maxCostError.value,
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          estimate['est_cost_max'] = value;
                                          if (double.parse(value) >
                                              double.parse(
                                                  minCostController.text)) {
                                            minCostError.value = "";
                                          }
                                          if (value.isEmpty) {
                                            maxCostError.value =
                                                'Please enter a maximum cost';
                                          } else if (double.tryParse(value) ==
                                              null) {
                                            maxCostError.value =
                                                'Please enter a valid number';
                                          } else if (double.parse(value) <
                                              double.parse(
                                                  minCostController.text)) {
                                            maxCostError.value =
                                                'Max cost cannot be less than min cost';
                                          } else {
                                            maxCostError.value = '';
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a maximum cost';
                                          }
                                          if (double.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          }
                                          if (double.parse(value) <
                                              double.parse(
                                                  minCostController.text)) {
                                            return 'Max cost cannot be less than min cost';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Obx(() => controller.repairEstimates.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: CustomButton(
                        text: "Sign Up",
                        borderRadius: 10,
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          //Check is there atleast one repair estimate
                          if (controller.repairEstimates.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please add at least one repair estimate",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: kDangerColor,
                              colorText: kWhiteColor,
                            );
                            return;
                          } else {
                            controller.signUp();
                          }
                          // if (_formKey.currentState!.validate()) {
                          //   controller.signUp();
                          // }
                        },
                        textColor: kWhiteColor,
                        buttonColor: kPrimaryColor),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addRepairEstimate();
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: kWhiteColor),
      ),
    );
  }
}
