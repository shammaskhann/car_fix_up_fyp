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
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'dart:developer';

import 'package:car_fix_up/Routes/routes.dart';

import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RemoteRepairScreen extends StatelessWidget {
  const RemoteRepairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapController mapController = Get.put(MapController());

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
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: mapController.initialPosition.value,
                zoom: 19,
              ),
              onMapCreated: mapController.onMapCreated,
              onCameraMove: mapController.onCameraMove,
              markers: {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: mapController.currentMapCenter.value,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
            ),
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
                      arguments: mapController.currentMapCenter.value);
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

class MapController extends GetxController {
  GoogleMapController? mapController;
  var initialPosition = const LatLng(24.8607, 67.0011).obs;
  var currentMapCenter = const LatLng(24.8607, 67.0011).obs;

  @override
  void onInit() {
    super.onInit();
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
    initialPosition.value =
        LatLng(_locationData.latitude!, _locationData.longitude!);
    currentMapCenter.value = initialPosition.value;

    // Animate the camera to the user's location
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialPosition.value,
          zoom: 19,
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Animate camera to the user's location once the map is created
    if (initialPosition.value.latitude != 24.8607 ||
        initialPosition.value.longitude != 67.0011) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: initialPosition.value,
            zoom: 19,
          ),
        ),
      );
    }
  }

  void onCameraMove(CameraPosition position) {
    currentMapCenter.value = position.target;
  }
}
