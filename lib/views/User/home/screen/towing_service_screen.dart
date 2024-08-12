import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/testing/Towing_Ride_Screen.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
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

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation({int retries = 5}) async {
    try {
      final locationData = await towingScreen.getCurrentLocation();
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
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
        await Future.delayed(Duration(seconds: 2));
        fetchCurrentLocation(retries: retries - 1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to get current location. Please try again.")),
        );
        print("Failed to get current location: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.19.sh),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
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
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Get.back();
                            },
                            color: Colors.white,
                          ),
                          IconButton(
                            icon: Icon(Icons.person),
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
                  onPressed: () {
                    if (currentLocation != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TowingRideScreen(
                            userLocation: currentLocation!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Unable to fetch current location. Please try again.")),
                      );
                      fetchCurrentLocation();
                    }
                  },
                  borderRadius: 10.0,
                  textColor: kWhiteColor,
                  buttonColor: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
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

  // geoCodingCordinates(String latitude, String longitude) async {
  //   final response = await http.get(
  //       Uri.parse(
  //           "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow"),
  //       headers: {"Accept": "application/json"});
  //   final responseJson = json.decode(response.body);
  //   log(responseJson.toString());
  //   String address = responseJson['results'][0]['formatted_address'];
  //   return address;
  // }
}
