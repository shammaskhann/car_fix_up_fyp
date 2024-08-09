import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/local-storage/localStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/user_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  UserController userController = Get.put(UserController());
  LocalStorageService local = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    bool isUser = await local.isUserLoggedIn();
    if (user != null) {
      Future.delayed(const Duration(seconds: 3), () async {
        if (isUser) {
          String? uid = await local.getUid();
          String? userType = await local.getUserType();
          String? name = await local.getName();
          String? password = await local.getPassword();
          String? email = await local.getEmail();
          String? contactNo = await local.getContactNo();
          String? deviceToken = await local.getDeviceToken();
          userController.setInfo(
              uid: uid!,
              userType: userType!,
              name: name!,
              password: password!,
              email: email!,
              contactNo: contactNo!,
              deviceToken: deviceToken!);
        }
        Get.offAllNamed(RouteName.dashboard);
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed(RouteName.onboarding);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kSplash,
              width: 250.w,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text("Car Fix Up",
                style: GoogleFonts.oxanium(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: kBlackColor)),
          ],
        ),
      ),
    );
  }
}
