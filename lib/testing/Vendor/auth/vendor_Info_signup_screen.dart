import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/shared/textfield.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_sign_up_controller.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_workshop_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorInfoScreen extends StatelessWidget {
  final VendorSignUpController controller =
      Get.put(VendorSignUpController(), permanent: true);

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
                  Text(
                    "Welcome to Car Fix Up!",
                    style: GoogleFonts.oxanium(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please fill in the details below to create an account.",
                    style: GoogleFonts.oxanium(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: kPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Vendor Signup",
                        style: GoogleFonts.oxanium(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor)),
                  ),
                  const SizedBox(height: 10),
                  // Email
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.emailAddress,
                      hintText: "Email",
                      controller: controller.emailController,
                      onChanged: (value) => controller.validateEmail(value),
                      placeHolder: controller.placeHolderEmail.value,
                    ),
                  ),
                  // Name
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Name",
                      controller: controller.nameController,
                      onChanged: (value) => controller.validateName(value),
                      placeHolder: controller.placeHolderName.value,
                    ),
                  ),
                  // Password
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.text,
                      hintText: "Password",
                      isPasswordField: true,
                      controller: controller.passwordController,
                      onChanged: (value) => controller.validatePassword(value),
                      placeHolder: controller.placeHolderPassword.value,
                    ),
                  ),
                  // Phone
                  Obx(
                    () => CustomTextField(
                      inputType: TextInputType.phone,
                      hintText: "Phone",
                      controller: controller.phoneController,
                      onChanged: (value) => controller.validatePhone(value),
                      placeHolder: controller.placeHolderPhone.value,
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
                      if (controller
                              .validateEmail(controller.emailController.text) &&
                          controller
                              .validateName(controller.nameController.text) &&
                          controller.validatePassword(
                              controller.passwordController.text) &&
                          controller
                              .validatePhone(controller.phoneController.text)) {
                        Get.to(() => WorkshopInfoScreen());
                      } else {
                        // Get.snackbar(
                        //     'Error', 'Please fill in all fields correctly');
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
