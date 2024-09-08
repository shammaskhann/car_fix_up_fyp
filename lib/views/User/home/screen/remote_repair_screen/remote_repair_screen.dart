import 'dart:developer';

import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RemoteRepairScreen extends StatefulWidget {
  const RemoteRepairScreen({super.key});

  @override
  _RemoteRepairScreenState createState() => _RemoteRepairScreenState();
}

class _RemoteRepairScreenState extends State<RemoteRepairScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition =
      const LatLng(24.8607, 67.0011); // Default to Karachi coordinates
  LatLng _currentMapCenter = const LatLng(24.8607, 67.0011);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check for location permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    // Update the initial position to user's current location
    setState(() {
      _initialPosition =
          LatLng(_locationData.latitude!, _locationData.longitude!);
      _currentMapCenter = _initialPosition;
    });

    // Animate the camera to the user's location
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialPosition,
          zoom: 19,
        ),
      ),
    );
  }

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
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 19,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Animate camera to the user's location once the map is created
              if (_initialPosition.latitude != 24.8607 ||
                  _initialPosition.longitude != 67.0011) {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _initialPosition,
                      zoom: 24,
                    ),
                  ),
                );
              }
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _currentMapCenter = position.target;
              });
            },
            markers: {
              Marker(
                markerId: const MarkerId('selected-location'),
                position: _currentMapCenter,
              ),
            },
          ),
          Positioned(
            bottom: 0.05.sh,
            right: 0.0,
            left: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: CustomButton(
                text: "Request Mobile Repair",
                onPressed: () {
                  Get.toNamed(RouteName.remoteRepairWorkshopList,
                      arguments: _currentMapCenter);
                },
                borderRadius: 10.0,
                textColor: kWhiteColor,
                buttonColor: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
