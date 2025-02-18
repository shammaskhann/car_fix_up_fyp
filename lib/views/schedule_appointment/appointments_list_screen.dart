import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:car_fix_up/controller/appointment_controller.dart';
import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/model/Vendor/workshop_review.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/shared/common_method.dart';

import 'package:car_fix_up/views/User/profile/customer_profile.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppointmentScheduleController _appointmentScheduleController = Get.put(
      AppointmentScheduleController(),
    );
    RxString _selectedStatus = "onHold".obs;
    Widget requestAppointment(
        Appointment appointment,
        Vendor vendor,
        AppointmentScheduleController _appointmentScheduleController,
        bool isConfirmationWidget) {
      Future<WorkshopReview?> getReview() async {
        return (appointment.isReviewed)
            ? await _appointmentScheduleController.getTheReview(appointment)
            : null;
      }

      RxBool isLoading = false.obs;
      return Padding(
        padding: const EdgeInsets.only(bottom: 0.0, right: 10, left: 10),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 0.02.sh,
            horizontal: 0.02.sw,
          ),
          height: 0.22.sh,
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
                          vendor.workshop.name,
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
              //for Mobile Repair
              if (appointment.isMobileRepair)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Remote Repair: ",
                            style: GoogleFonts.oxanium(
                              color: kBlackText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            appointment.isMobileRepair ? "Yes" : "No",
                            style: GoogleFonts.oxanium(
                              color: kBlackText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Location
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: kBlackText,
                            size: 20.sp,
                          ),
                          InkWell(
                            onTap: () {
                              Completer<GoogleMapController> _controller =
                                  Completer();

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Container(
                                    height: 0.5.sh,
                                    width: 0.8.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            appointment.location?.latitude ?? 0,
                                            appointment.location?.longitude ??
                                                0),
                                        zoom: 15,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId:
                                              MarkerId(vendor.workshop.name),
                                          position: LatLng(
                                              appointment.location?.latitude ??
                                                  0,
                                              appointment.location?.longitude ??
                                                  0),
                                          infoWindow: InfoWindow(
                                            title: vendor.workshop.name,
                                            snippet:
                                                "${vendor.workshop.area},${vendor.workshop.city}",
                                          ),
                                        ),
                                      },
                                      zoomControlsEnabled: false,
                                      scrollGesturesEnabled: false,
                                      rotateGesturesEnabled: false,
                                      tiltGesturesEnabled: false,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(0.01.sw),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: kPrimaryColor, width: 2),
                              ),
                              child: Text(
                                "View on Map",
                                style: GoogleFonts.oxanium(
                                  color: kPrimaryColor,
                                  fontSize: 0.03.sw,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
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
                          (appointment.isReviewed)
                              ? FutureBuilder(
                                  future: getReview(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text("Error: ${snapshot.error}"),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    WorkshopReview review = snapshot.data!;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Rating: ${review.rating}",
                                              style: GoogleFonts.oxanium(
                                                color: kBlackText,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: kPrimaryColor,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Review: ${review.comment}",
                                          style: GoogleFonts.oxanium(
                                            color: kBlackText,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    double rating = 0;
                                    TextEditingController commentController =
                                        TextEditingController();
                                    showBottomSheet(
                                        enableDrag: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        sheetAnimationStyle: AnimationStyle(
                                          curve: Curves.easeInOut,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          reverseDuration:
                                              const Duration(milliseconds: 500),
                                        ),
                                        builder: (context) {
                                          return Container(
                                            height: 0.4.sh,
                                            width: 1.sw,
                                            decoration: BoxDecoration(
                                                color: kWhiteColor,
                                                boxShadow: [
                                                  //Most 3D effect
                                                  BoxShadow(
                                                    color: kBlackText
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 1,
                                                  ),
                                                  BoxShadow(
                                                    color: kBlackText
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                )),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                //Custom Drag Handle
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0),
                                                  child: Container(
                                                    height: 0.01.sh,
                                                    width: 0.2.sw,
                                                    decoration: BoxDecoration(
                                                      color: kBlackText
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Give a Review",
                                                  style: GoogleFonts.oxanium(
                                                    color: kBlackText,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 0.01.sh,
                                                ),
                                                RatingBar(
                                                  alignment: Alignment.center,
                                                  onRatingChanged: (value) {
                                                    rating = value;
                                                  },
                                                  filledIcon: Icons.star,
                                                  emptyIcon: Icons.star_border,
                                                  halfFilledIcon:
                                                      Icons.star_half,
                                                  isHalfAllowed: true,
                                                  filledColor: kPrimaryColor,
                                                  emptyColor: kBlackText,
                                                  halfFilledColor:
                                                      kPrimaryColor,
                                                  size: 32,
                                                ),
                                                //Text Field
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 30.0,
                                                      horizontal: 20),
                                                  child: TextFormField(
                                                    controller:
                                                        commentController,
                                                    decoration: InputDecoration(
                                                      hintText: "Comment",
                                                      hintStyle:
                                                          GoogleFonts.oxanium(
                                                        color: kBlackText,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Obx(
                                                  () => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CustomButton(
                                                      onPressed: () async {
                                                        isLoading.value = true;
                                                        await _appointmentScheduleController
                                                            .giveReview(
                                                                appointment,
                                                                rating,
                                                                commentController
                                                                    .text);
                                                        isLoading.value = false;
                                                        _selectedStatus.value =
                                                            "";
                                                        _selectedStatus.value =
                                                            "completed";
                                                        Get.back();
                                                      },
                                                      text: "Submit",
                                                      buttonColor:
                                                          kPrimaryColor,
                                                      borderRadius: 10,
                                                      textColor: kWhiteColor,
                                                      isLoading:
                                                          isLoading.value,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    // isLoading.value = true;
                                    // await _appointmentScheduleController
                                    //     .giveReview(appointment, 3,
                                    //         "Impressive Service");
                                    // isLoading.value = false;
                                    // _selectedStatus.value = "";
                                    // _selectedStatus.value = "completed";
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Obx(
                                    () => (isLoading.value)
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              color: kWhiteColor,
                                            ),
                                          )
                                        : Text(
                                            "Give a Review",
                                            style: GoogleFonts.oxanium(
                                              color: kWhiteColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  )),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _appointmentScheduleController
                                  .cancelAppointment(appointment);
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
                          onPressed: () {
                            Get.to(() => const CustomerProfileScreen());
                          },
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
          Expanded(
            child: Obx(
              () => _appointmentScheduleController.isLoading.value == false
                  ? Column(
                      children: [
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
                                              color: _selectedStatus.value ==
                                                      "onHold"
                                                  ? kPrimaryColor
                                                  : kWhiteColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8))),
                                          child: Center(
                                              child: Text(
                                            "On Hold",
                                            style: GoogleFonts.oxanium(
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    _selectedStatus.value ==
                                                            "onHold"
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: _selectedStatus.value ==
                                                        "onHold"
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
                                              color: _selectedStatus.value ==
                                                      "confirmed"
                                                  ? kPrimaryColor
                                                  : kWhiteColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(0),
                                                      bottomLeft:
                                                          Radius.circular(0))),
                                          child: Center(
                                              child: Text(
                                            "Confirmed",
                                            style: GoogleFonts.oxanium(
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    _selectedStatus.value ==
                                                            "confirmed"
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: _selectedStatus.value ==
                                                        "confirmed"
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
                                              color: _selectedStatus.value ==
                                                      "completed"
                                                  ? kPrimaryColor
                                                  : kWhiteColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8))),
                                          child: Center(
                                              child: Text(
                                            "Completed",
                                            style: GoogleFonts.oxanium(
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    _selectedStatus.value ==
                                                            "completed"
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: _selectedStatus.value ==
                                                        "completed"
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
                                  ? _appointmentScheduleController
                                      .getUserOnHoldAppointments()
                                  : _selectedStatus.value == "confirmed"
                                      ? _appointmentScheduleController
                                          .getUserConfirmAppointments()
                                      : _appointmentScheduleController
                                          .getUserCompletedAppointments(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
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
                                  key: PageStorageKey('appointmentsList'),
                                  padding: EdgeInsets.only(bottom: 0.1.sh),
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    Appointment appointment =
                                        snapshot.data![index];
                                    Vendor vendor =
                                        _appointmentScheduleController.vendors!
                                            .firstWhere((element) =>
                                                element.uid ==
                                                appointment.vendorUid);
                                    return requestAppointment(
                                      appointment,
                                      vendor,
                                      _appointmentScheduleController,
                                      _selectedStatus.value == "completed",
                                    );
                                    // return FutureBuilder<Vendor>(
                                    //   future: VendorServices()
                                    //       .getVendorByUid(appointment.vendorUid),
                                    //   builder: (context, vendorSnapshot) {
                                    //     if (vendorSnapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return CircularProgressIndicator();
                                    //     }
                                    //     if (vendorSnapshot.hasError) {
                                    //       return Center(
                                    //         child: Text("Error: ${vendorSnapshot.error}"),
                                    //       );
                                    //     }
                                    //     if (!vendorSnapshot.hasData) {
                                    //       return const Center(
                                    //         child: Text("Vendor not found"),
                                    //       );
                                    //     }
                                    //     Vendor vendor = vendorSnapshot.data!;
                                    //     return requestAppointment(
                                    //       appointment,
                                    //       vendor,
                                    //       _appointmentScheduleController,
                                    //       _selectedStatus.value == "completed",
                                    //     );
                                    //   },
                                    // );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                          height: 0.05.sh,
                          width: 0.1.sw,
                          child: CircularProgressIndicator())),
            ),
          ),
        ],
      ),
    );
  }
}
