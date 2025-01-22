import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/shared/textfield.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_sign_up_controller.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_workshop_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkshopInfoScreen extends StatelessWidget {
  final VendorSignUpController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyText,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  30.h.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" Car Fix Up ",
                          style: GoogleFonts.oxanium(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor)),
                      SvgPicture.asset("assets/images/car.svg", width: 100.w),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Welcoming Text

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Workshop Info",
                        style: GoogleFonts.oxanium(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor)),
                  ),
                  const SizedBox(height: 10),
                  // Workshop Name
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Workshop Name",
                      controller: controller.workshopNameController,
                      onChanged: (value) =>
                          controller.validateWorkshopName(value),
                      placeHolder: controller.placeHolderWorkshopName.value,
                    ),
                  ),
                  // Workshop Description
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Workshop Description",
                      controller: controller.workshopDescController,
                      onChanged: (value) =>
                          controller.validateWorkshopDesc(value),
                      placeHolder: controller.placeHolderWorkshopDesc.value,
                    ),
                  ),
                  // Area
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Area",
                      controller: controller.workshopAreaController,
                      onChanged: (value) =>
                          controller.validateWorkshopArea(value),
                      placeHolder: controller.placeHolderWorkshopArea.value,
                    ),
                  ),
                  // City
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "City",
                      controller: controller.workshopCityController,
                      onChanged: (value) =>
                          controller.validateWorkshopCity(value),
                      placeHolder: controller.placeHolderWorkshopCity.value,
                    ),
                  ),
                  // Operational Time
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Operational Time (09:00 AM / 11:00 PM)",
                      controller: controller.operationalTimeController,
                      onChanged: (value) {
                        controller.validateOperationalTime(value);
                        controller.validateTimeFormat(
                            controller.operationalTimeController.text);
                      },
                      placeHolder: controller.placeHolderOperationalTime.value,
                    ),
                  ),
                  // Close Time
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Close Time (09:00 AM / 11:00 PM)",
                      controller: controller.closeTimeController,
                      onChanged: (value) {
                        controller.validateCloseTime(value);
                        controller.validateTimeFormat(
                            controller.operationalTimeController.text);
                      },
                      placeHolder: controller.placeHolderCloseTime.value,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Obx(
                  () => CustomButton(
                    text: "Next",
                    onPressed: () {
                      controller.validateWorkshopName(
                          controller.workshopNameController.text);
                      controller.validateWorkshopDesc(
                          controller.workshopDescController.text);
                      controller.validateWorkshopArea(
                          controller.workshopAreaController.text);
                      controller.validateWorkshopCity(
                          controller.workshopCityController.text);
                      controller.validateOperationalTime(
                          controller.operationalTimeController.text);
                      controller.validateCloseTime(
                          controller.closeTimeController.text);

                      if (controller.validateWorkshopName(
                              controller.workshopNameController.text) &&
                          controller.validateWorkshopDesc(
                              controller.workshopDescController.text) &&
                          controller.validateWorkshopArea(
                              controller.workshopAreaController.text) &&
                          controller.validateWorkshopCity(
                              controller.workshopCityController.text) &&
                          controller.validateOperationalTime(
                              controller.operationalTimeController.text) &&
                          controller.validateCloseTime(
                              controller.closeTimeController.text)) {
                        Get.to(() => WorkshopLocationScreen());
                      } else {
                        // Get.snackbar('Error', 'Please enter valid times');
                      }
                    },
                    isLoading: controller.isLoading.value,
                    textColor: kWhiteColor,
                    buttonColor: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//small description for the mechanic workshop of tuning sport cars below
// We are specialized in tuning sport cars, we have a team of professional mechanics that will take care of your car and make it look like a brand new car. We have the best prices in the market and we are always looking for the best quality in our services. We are located in the heart of the city and we are open from 9:00 AM to 11:00 PM. Come and visit us!