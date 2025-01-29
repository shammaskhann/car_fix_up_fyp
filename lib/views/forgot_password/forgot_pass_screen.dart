import 'dart:developer';

import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/shared/textfield.dart';
import 'package:car_fix_up/views/forgot_password/forgot_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    ForgotPasswordController controller = ForgotPasswordController();
    return Scaffold(
      backgroundColor: kGreyText,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(kScheduledService, width: 300.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.w,
                      height: 2.h,
                      color: kPrimaryColor,
                    ),
                    Text(" Car Fix Up ",
                        style: GoogleFonts.oxanium(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryLightColor)),
                    Container(
                      width: 100.w,
                      height: 2.h,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Forgot Password",
                      style: GoogleFonts.oxanium(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: kWhiteColor)),
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => CustomTextField(
                    hintText: "  Email",
                    controller: controller.emailController,
                    inputType: TextInputType.emailAddress,
                    placeHolder: controller.placeHolderEmail.value,
                    onChanged: (value) {
                      log(value);
                      controller.validateEmail(value);
                    },
                  ),
                ),
                // Obx(
                //   () => Visibility(
                //     visible: controller.placeHolderEmail.value.isNotEmpty,
                //     child: Padding(
                //       padding: EdgeInsets.only(left: 10.w),
                //       child: Text(
                //         controller.placeHolderEmail.value,
                //         style: GoogleFonts.oxanium(
                //             fontSize: 12.sp,
                //             fontWeight: FontWeight.w500,
                //             color: kPrimaryColor),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 10.h),
                Obx(
                  () => CustomButton(
                    text: "Send Reset Email",
                    onPressed: () async {
                      controller.sendPasswordResetEmail();
                    },
                    textColor: kWhiteColor,
                    isLoading: controller.isLoading.value,
                    buttonColor: kPrimaryLightColor,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Remember your password? ",
                        style: GoogleFonts.oxanium(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: kWhiteColor)),
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteName.login);
                      },
                      child: Text("Login",
                          style: GoogleFonts.oxanium(
                              decorationThickness: 2,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
