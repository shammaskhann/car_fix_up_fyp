import 'dart:developer';

import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/towing_rides/towing_ride_servie.dart';
import 'package:car_fix_up/testing/Vendor/towing_location_sender/towing_location_Sender_Screen.dart';
import 'package:car_fix_up/testing/Vendor/vendorProfile/vendor_profile_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TowingReqScreen extends StatefulWidget {
  const TowingReqScreen({super.key});

  @override
  _TowingReqScreenState createState() => _TowingReqScreenState();
}

class _TowingReqScreenState extends State<TowingReqScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    void openGoogleMaps(double latitude, double longitude) async {
      final String googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open Google Maps';
      }
    }

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Stack(
        children: [
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              height: 0.25.sh,
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
                      "Towing Requests",
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
          Container(
            height: 0.74.sh,
            padding: EdgeInsets.only(top: 0.19.sh),
            child: StreamBuilder(
              stream: TowingRideService().getTowingActiveRequests(),
              builder: (context, snapshot) {
                log('Data: ${snapshot.data}');
                log('Data: ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.data == null ||
                    snapshot.data!.isEmpty ||
                    snapshot.data!.length == 0 ||
                    snapshot.data == []) {
                  return const Center(
                    child: Text('No Towing Ride Requests'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    //pickup location of the user
                    GeoPoint pickup = snapshot.data![index].get("pickup");
                    String requesterId =
                        snapshot.data![index].get("requesterId");
                    String requesterName =
                        snapshot.data![index].get("requesterName");
                    String requestId = snapshot.data![index].id;
                    String status = snapshot.data![index].get("status");

                    String? accepterId =
                        snapshot.data![index].get("accepterId");
                    bool isAccepted = snapshot.data![index].get("isAccepted");
                    if (isAccepted) {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      if (uid == accepterId && !_hasNavigated) {
                        log('Navigating to location sender screen');
                        _hasNavigated = true;
                        Future.microtask(() {
                          Get.to(() {
                            return LocationSenderScreen(
                              requestId: requestId,
                              pickup: pickup,
                            );
                          });
                        });
                      }
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                      child: Container(
                        height: 0.2.sh,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: kBlackColor.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: -2,
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            //Request details
                            //Id at center
                            Center(
                              child: Text(
                                "ID: $requestId",
                                style: GoogleFonts.oxanium(
                                  color: kPrimaryColor,
                                  fontSize: 0.04.sw,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            //Requester name
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.05.sw),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name: $requesterName",
                                    style: GoogleFonts.oxanium(
                                      color: kPrimaryColor,
                                      fontSize: 0.04.sw,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openGoogleMaps(
                                          pickup.latitude, pickup.longitude);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(0.01.sw),
                                      decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: kPrimaryColor, width: 2),
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
                            ),
                            Row(
                              children: [
                                //status
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.05.sw),
                                  child: Text(
                                    "Status: $status",
                                    style: GoogleFonts.oxanium(
                                      color: kPrimaryColor,
                                      fontSize: 0.04.sw,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  TowingRideService().acceptTowingRequest(
                                      requestId, userController.uid);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         LocationSenderScreen(
                                  //       requestId: requestId,
                                  //     ),
                                  //   ),
                                  // );
                                  Get.to(
                                    () {
                                      return LocationSenderScreen(
                                        requestId: requestId,
                                        pickup: pickup,
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
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
                            ),
                            SizedBox(
                              height: 0.01.sh,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
