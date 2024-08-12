import 'dart:async';

import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final Completer<GoogleMapController> _controller =
    //     Completer<GoogleMapController>();

    // const CameraPosition _kGooglePlex = CameraPosition(
    //   target: LatLng(37.42796133580664, -122.085749655962),
    //   zoom: 14.4746,
    // );
    // return Scaffold(
    //   backgroundColor: kWhiteColor,
    //   body: GoogleMap(
    //     zoomControlsEnabled: true,
    //     myLocationEnabled: true,
    //     myLocationButtonEnabled: true,
    //     initialCameraPosition: _kGooglePlex,
    //     mapType: MapType.normal,
    //     onMapCreated: (controller) => {
    //       _controller.complete(controller),
    //     },
    //   ),
    // );

    return Scaffold(
        backgroundColor: kWhiteColor,
        body: Column(
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
                          "Chat",
                          style: GoogleFonts.oxanium(
                            color: kPrimaryColor,
                            fontSize: 0.06.sw,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  String imgUrl = "assets/images/workshop1.png";
                  String name = "User Name";
                  String lastMsg = "Message";
                  String time = "12:00 PM";
                  int unreadCount = 2;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 0.02.sw,
                        vertical: 0.01.sh,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.02.sw,
                        vertical: 0.01.sh,
                      ),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(0.02.sw),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300]!,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 0.06.sw,
                            backgroundImage: AssetImage(imgUrl),
                          ),
                          SizedBox(width: 0.02.sw),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.oxanium(
                                  color: kBlackColor,
                                  fontSize: 0.04.sw,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lastMsg,
                                style: GoogleFonts.oxanium(
                                  color: kPrimaryColor,
                                  fontSize: 0.03.sw,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                time,
                                style: GoogleFonts.oxanium(
                                  color: kBlackColor,
                                  fontSize: 0.03.sw,
                                ),
                              ),
                              if (unreadCount > 0)
                                Container(
                                  height: 0.04.sw,
                                  width: 0.04.sw,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius:
                                        BorderRadius.circular(0.02.sw),
                                  ),
                                  child: Center(
                                    child: Text(
                                      unreadCount.toString(),
                                      style: GoogleFonts.oxanium(
                                        color: kWhiteColor,
                                        fontSize: 0.03.sw,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
