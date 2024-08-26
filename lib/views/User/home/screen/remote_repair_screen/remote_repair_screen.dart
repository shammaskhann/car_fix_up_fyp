import 'package:car_fix_up/resources/constatnt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RemoteRepairScreen extends StatelessWidget {
  const RemoteRepairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Remote Repair Appointment',
          style: GoogleFonts.oxanium(
            color: kWhiteColor,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Center(
        child: Text('Remote Repair Screen'),
      ),
    );
  }
}
