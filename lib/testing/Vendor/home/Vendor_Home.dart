import 'package:car_fix_up/controller/appointment_controller.dart';
import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/common_method.dart';
import 'package:car_fix_up/views/User/home/controller/home_controller.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

enum AppointmentStatus { onHold, confirmed, completed }

class VendorHomeview extends StatelessWidget {
  const VendorHomeview({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController _homeController = Get.put(HomeController());
    AppointmentScheduleController _appointmentScheduleController =
        Get.put(AppointmentScheduleController());

    RxString _selectedStatus = "onHold".obs;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: 0.25.sh,
                  width: 1.sw,
                  color: kPrimaryColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.07.sh),
                        child: Text(
                          "Welcome Vendor",
                          style: GoogleFonts.oxanium(
                            color: kBlackText,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.02.sh),
                        child: Text(
                          "Manage your appointments here",
                          style: GoogleFonts.oxanium(
                            color: kBlackText,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
                child: Container(
                  height: 0.06.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: kBlackText.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => Expanded(
                            child: InkWell(
                              onTap: () {
                                _selectedStatus.value = "onHold";
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: _selectedStatus.value == "onHold"
                                        ? kPrimaryColor
                                        : kWhiteColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8))),
                                child: Center(
                                    child: Text(
                                  "On Hold",
                                  style: GoogleFonts.oxanium(
                                      fontSize: 14.sp,
                                      fontWeight:
                                          _selectedStatus.value == "onHold"
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color: _selectedStatus.value == "onHold"
                                          ? kWhiteColor
                                          : kBlackText),
                                )),
                              ),
                            ),
                          )),
                      Obx(() => Expanded(
                            child: InkWell(
                              onTap: () {
                                _selectedStatus.value = "confirmed";
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: _selectedStatus.value == "confirmed"
                                        ? kPrimaryColor
                                        : kWhiteColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        bottomLeft: Radius.circular(0))),
                                child: Center(
                                    child: Text(
                                  "Confirmed",
                                  style: GoogleFonts.oxanium(
                                      fontSize: 14.sp,
                                      fontWeight:
                                          _selectedStatus.value == "confirmed"
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _selectedStatus.value == "confirmed"
                                              ? kWhiteColor
                                              : kBlackText),
                                )),
                              ),
                            ),
                          )),
                      Obx(() => Expanded(
                            child: InkWell(
                              onTap: () {
                                _selectedStatus.value = "completed";
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: _selectedStatus.value == "completed"
                                        ? kPrimaryColor
                                        : kWhiteColor,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Center(
                                    child: Text(
                                  "Completed",
                                  style: GoogleFonts.oxanium(
                                      fontSize: 14.sp,
                                      fontWeight:
                                          _selectedStatus.value == "completed"
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _selectedStatus.value == "completed"
                                              ? kWhiteColor
                                              : kBlackText),
                                )),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => StreamBuilder<List<Appointment>>(
                    stream: _selectedStatus.value == "onHold"
                        ? _appointmentScheduleController.getOnHoldAppointments()
                        : _selectedStatus.value == "confirmed"
                            ? _appointmentScheduleController
                                .getConfirmedAppointments()
                            : _appointmentScheduleController
                                .getCompletedAppointments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "No Appointments",
                            style: GoogleFonts.oxanium(
                              color: kBlackText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: GoogleFonts.oxanium(
                              color: kBlackText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        log("Data: ${snapshot.data}");
                        List<Appointment>? appointments = snapshot.data;
                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: 0.1.sh),
                          itemCount: appointments!.length,
                          itemBuilder: (context, index) {
                            return requestAppointment(
                              appointments[index],
                              _appointmentScheduleController,
                              _selectedStatus.value == "confirmed"
                                  ? true
                                  : false,
                              _selectedStatus.value == "completed"
                                  ? true
                                  : false,
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget requestAppointment(
      Appointment appointment,
      AppointmentScheduleController _appointmentScheduleController,
      bool isConfirmationWidget,
      bool isCompletedWidget) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0, right: 10, left: 10),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 0.02.sh,
          horizontal: 0.02.sw,
        ),
        height: 0.2.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kBlackText.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Name
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style: GoogleFonts.oxanium(
                          color: kBlackText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        appointment.userName,
                        style: GoogleFonts.oxanium(
                          color: kBlackText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  //Date of Appointment
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: kBlackText,
                        size: 20.sp,
                      ),
                      Text(
                        getDateFormattedAsDDMMYYYY(
                            appointment.dateOfAppointment),
                        style: GoogleFonts.oxanium(
                          color: kBlackText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // User Car Plate
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Car Plate: ",
                        style: GoogleFonts.oxanium(
                          color: kBlackText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        appointment.userCarPlate,
                        style: GoogleFonts.oxanium(
                          color: kBlackText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Time Slot
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: kBlackText,
                        size: 20.sp,
                      ),
                      Text(
                        appointment.timeSlot,
                        style: GoogleFonts.oxanium(
                          color: kBlackText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Accept and Reject Button in a row at bottom stick
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: isCompletedWidget
                  ? (appointment.isReviewed)
                      ? Text("Reviewed")
                      : Text("Not Reviewed")
                  : isConfirmationWidget
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _appointmentScheduleController
                                    .completeTheAppointment(
                                        appointment.appointmentId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Mark As Complete",
                                style: GoogleFonts.oxanium(
                                  color: kWhiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _appointmentScheduleController
                                    .confirmAppointment(appointment);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Accept",
                                style: GoogleFonts.oxanium(
                                  color: kWhiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // _appointmentScheduleController
                                //     .rejectTheOnHoldAppointment(
                                //         appointments[index]
                                //             .appointmentId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDangerColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Reject",
                                style: GoogleFonts.oxanium(
                                  color: kWhiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
