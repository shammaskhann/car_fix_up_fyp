import 'dart:developer';
import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:car_fix_up/views/User/home/controller/home_controller.dart';
import 'package:car_fix_up/views/User/home/screen/towing_service/towing_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    UserController userController = Get.find<UserController>();
    return Scaffold(
        backgroundColor: Colors.white,
        //generate a list of items
        body: Column(
          children: [
            ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: 0.25.sh, // Set the height to 20% of the screen height
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
                        "Welcome to Car Fix Up",
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
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ZegoSendCallInvitationButton(
                  //   onPressed:
                  //       (String value1, String value2, List<String> value3) {
                  //     Get.toNamed(RouteName.videoCall, arguments: "sos_call");
                  //   },
                  //   isVideoCall: true,
                  //   //You need to use the resourceID that you created in the subsequent steps.
                  //   //Please continue reading this document.
                  //   resourceID: "car_fix_up",
                  //   invitees: [
                  //     ZegoUIKitUser(
                  //       id: "101",
                  //       name: "vendor@test.com",
                  //     ),
                  //   ],
                  // ),
                  //Live Dignostic Video Call Banner
                  Padding(
                    padding: EdgeInsets.only(
                      top: 0.02.sh,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed(RouteName.remoteRepair),
                          // onTap: () => PushNotification.sendNotification(
                          //     userController.deviceToken,
                          //     "Live Dignostic Call Incoming",
                          //     "A Customer is seeking a Live Dignostic on Video Call",
                          //     {
                          //       "notification_type": "CALL_NOTIFICATION",
                          //       "callID": "sos_call",
                          //       "userID": "102",
                          //     }),
                          child: Container(
                            height: 0.3.sh,
                            width: 0.4.sw,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/roadside-assistance.png",
                                  height: 0.2.sh,
                                  width: 0.2.sw,
                                ),
                                Text(
                                  "Mobile Repair\nService",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oxanium(
                                    color: kPrimaryColor,
                                    fontSize: 0.04.sw,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 0.03.sw,
                        // ),
                        InkWell(
                          onTap: () =>
                              Get.to(() => const TowingScreenServices()),
                          // onTap: () => Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             const TowingScreenServices(
                          //                 // userLatLng: <String, double>{
                          //                 //   "lat": 24.7732,
                          //                 //   "lng": 67.0762,
                          //                 // },
                          //                 ))),
                          child: Container(
                            height: 0.3.sh,
                            width: 0.4.sw,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/towing.png",
                                  height: 0.2.sh,
                                  width: 0.2.sw,
                                ),
                                Text(
                                  "Towing Service",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oxanium(
                                    color: kPrimaryColor,
                                    fontSize: 0.04.sw,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 0.02.sh,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => Get.toNamed(
                              RouteName.repairEstWorkshopList,
                            ),
                            child: Container(
                              height: 0.3.sh,
                              width: 0.4.sw,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      "assets/images/repairEstimate.png",
                                      height: 0.2.sh,
                                      width: 0.2.sw,
                                      fit: BoxFit.contain),
                                  Text(
                                    "Realtime-Repair Estimate Service",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oxanium(
                                      color: kPrimaryColor,
                                      fontSize: 0.04.sw,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(RouteName.videoCall,
                                arguments: "sos_call"),
                            child: Container(
                              height: 0.3.sh,
                              width: 0.4.sw,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: SvgPicture.asset(
                                      "assets/images/live_dignostic.svg",
                                      height: 0.2.sh,
                                      width: 0.2.sw,
                                    ),
                                  ),
                                  Text(
                                    "Live Dignostic\nService",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oxanium(
                                      color: kPrimaryColor,
                                      fontSize: 0.04.sw,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ])
          ],
        ));
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
