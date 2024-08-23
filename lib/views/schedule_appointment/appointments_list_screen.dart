import 'package:car_fix_up/controller/appointment_controller.dart';
import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/shared/common_method.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppointmentScheduleController _appointmentScheduleController =
        AppointmentScheduleController();
    RxString _selectedStatus = "onHold".obs;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              height: 0.25.sh,
              width: 1.sw,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kBlackColor, Colors.grey[800]!],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.05.sh),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu_rounded),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          color: Colors.white,
                        ),
                        IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.02.sh),
                    child: Text(
                      "Scheduled Appointments",
                      style: GoogleFonts.oxanium(
                        color: kPrimaryColor,
                        fontSize: 0.06.sw,
                        fontWeight: FontWeight.bold,
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
                                  fontWeight: _selectedStatus.value == "onHold"
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
                                  color: _selectedStatus.value == "confirmed"
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
                                  color: _selectedStatus.value == "completed"
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
              () => FutureBuilder<List<Appointment>>(
                future: _selectedStatus.value == "onHold"
                    ? _appointmentScheduleController.getUserOnHoldAppointments()
                    : _selectedStatus.value == "confirmed"
                        ? _appointmentScheduleController
                            .getUserConfirmAppointments()
                        : _appointmentScheduleController
                            .getUserCompletedAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Appointments",
                        style: GoogleFonts.oxanium(
                          color: kBlackColor,
                          fontSize: 0.06.sw,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 0.1.sh),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Appointment appointment = snapshot.data![index];
                      return FutureBuilder<Vendor>(
                        future: VendorServices()
                            .getVendorByUid(appointment.vendorUid),
                        builder: (context, vendorSnapshot) {
                          if (vendorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }
                          if (vendorSnapshot.hasError) {
                            return Center(
                              child: Text("Error: ${vendorSnapshot.error}"),
                            );
                          }
                          if (!vendorSnapshot.hasData) {
                            return const Center(
                              child: Text("Vendor not found"),
                            );
                          }
                          Vendor vendor = vendorSnapshot.data!;
                          return requestAppointment(
                            appointment,
                            vendor,
                            _appointmentScheduleController,
                            _selectedStatus.value == "completed",
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget requestAppointment(
      Appointment appointment,
      Vendor vendor,
      AppointmentScheduleController _appointmentScheduleController,
      bool isConfirmationWidget) {
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
            // Waiting for Confirmation Text
            const Spacer(),
            // Accept and Reject Button in a row at bottom stick
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: isConfirmationWidget
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // _appointmentScheduleController
                            //     .completeTheAppointment(
                            //         appointment.appointmentId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Give a Review",
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
                            // _appointmentScheduleController
                            //     .confirmAppointment(appointment);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDangerColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Cancel",
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
