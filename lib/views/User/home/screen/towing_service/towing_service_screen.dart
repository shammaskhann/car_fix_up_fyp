import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/towing_rides/towing_ride_servie.dart';
import 'package:car_fix_up/services/local-storage/localStorage.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/shared/typing_effect.dart';
import 'package:car_fix_up/views/User/home/screen/towing_service/Towing_Ride_Screen.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/monitoring/v3.dart';
import 'package:location/location.dart' as location;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class TowingScreenServices extends StatefulWidget {
  const TowingScreenServices({
    super.key,
  });

  @override
  _TowingScreenServicesState createState() => _TowingScreenServicesState();
}

class _TowingScreenServicesState extends State<TowingScreenServices> {
  TowingScreen towingScreen = Get.put(TowingScreen());
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newMapController;
  Set<Marker> _markers = {};
  LatLng? currentLocation;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await fetchCurrentLocation();
    await existingRunningRide();
  }

  Future<void> existingRunningRide() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final RideRunning = await TowingRideService().getTowingActiveRequests();
    RideRunning.listen((event) {
      event.forEach((element) {
        if (element.get("requesterId") == uid &&
            (element.get("status") == "in_progress" ||
                element.get("status") == "accepted")) {
          log("Ride is already running");
          Get.off(() => TowingRideScreen(
                userLocation: currentLocation!,
                requestId: element.id,
              ));
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TowingRideScreen(
          //       userLocation: currentLocation!,
          //       requestId: element.id,
          //     ),
          //   ),
          // );
        }
      });
    });
  }

  Future<void> fetchCurrentLocation({int retries = 5}) async {
    try {
      final locationData = await towingScreen.getCurrentLocation();
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentLocation!,
          ),
        );
      });
      newMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation!,
            zoom: 14.0,
          ),
        ),
      );
    } catch (e) {
      if (retries > 0) {
        await Future.delayed(const Duration(seconds: 2));
        fetchCurrentLocation(retries: retries - 1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Failed to get current location. Please try again.")),
        );
        print("Failed to get current location: $e");
      }
    }
  }

  final _towingRideService = TowingRideService();
  String? requestID;
  void showLoadingScreen() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userName = await LocalStorageService().getName();

    setState(() {
      isLoading = true;
    });
    requestID = await _towingRideService.sendTowingRideRequestStream(
      currentLocation!,
      uid,
      userName ?? "",
    );

    // Set a timeout of 5 minutes
    Future.delayed(const Duration(minutes: 5), () async {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
        await _towingRideService.deleteTowingRequest(requestID!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request timed out. Please try again."),
          ),
        );
      }
    });

    final isAcceptedStream =
        _towingRideService.checkIsTowingRideAccepted(requestID!);
    isAcceptedStream.listen((isAccepted) {
      if (isAccepted) {
        setState(() {
          isLoading = false;
        });
        if (currentLocation != null) {
          log("Navigating to Towing Ride Screen");
          Get.to(() => TowingRideScreen(
                userLocation: currentLocation!,
                requestId: requestID!,
              ));
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TowingRideScreen(
          //       userLocation: currentLocation!,
          //       requestId: requestID!,
          //     ),
          //   ),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Unable to fetch current location. Please try again.")),
          );
          fetchCurrentLocation();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.19.sh),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 8.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                newMapController = controller;
              },
            ),
          ),
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
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Get.back();
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
                      "Towing Services",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.05.sh,
            right: 0.0,
            left: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: CustomButton(
                text: "Request Towing",
                onPressed: showLoadingScreen,
                borderRadius: 10.0,
                textColor: kWhiteColor,
                buttonColor: kPrimaryColor,
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TypingEffect(
                      text: "Requesting Towing Ride...",
                      textStyle: GoogleFonts.oxanium(
                        color: kPrimaryColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: CustomButton(
                          borderRadius: 15,
                          text: "Cancel",
                          onPressed: () {
                            _towingRideService.deleteTowingRequest(requestID!);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          textColor: kWhiteColor,
                          buttonColor: kPrimaryColor),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TowingScreen extends GetxController {
  location.Location _location = location.Location();

  void getCurrentPostion() async {
    final locationData = await getCurrentLocation();
    print(locationData);
  }

  Future<location.LocationData> getCurrentLocation() async {
    final locationData = await _location.getLocation();
    return locationData;
  }

  getEnableLocationService() async {
    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      final result = await _location.requestService();
      return result;
    }
    return true;
  }
}
