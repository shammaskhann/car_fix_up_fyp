import 'dart:async';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_repair_estimates_screen.dart';
import 'package:car_fix_up/testing/Vendor/auth/vendor_sign_up_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WorkshopLocationScreen extends StatefulWidget {
  const WorkshopLocationScreen({super.key});

  @override
  State<WorkshopLocationScreen> createState() => _WorkshopLocationScreenState();
}

class _WorkshopLocationScreenState extends State<WorkshopLocationScreen> {
  LatLng? _selectedLocation;
  final Completer<GoogleMapController> _controller = Completer();
  final VendorSignUpController controller = Get.find();
  static const LatLng _defaultLocation = LatLng(24.8607, 67.0011); // Karachi

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Error",
        "Location services are disabled.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: kDangerColor,
        colorText: kWhiteColor,
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Error",
          "Location permissions are denied.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: kDangerColor,
          colorText: kWhiteColor,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Error",
        "Location permissions are permanently denied.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: kDangerColor,
        colorText: kWhiteColor,
      );
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the camera to the user's location
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Select Workshop Location',
          style: GoogleFonts.oxanium(color: kWhiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: _defaultLocation, // Default location (Karachi)
              zoom: 14,
            ),
            onCameraMove: (CameraPosition position) {
              setState(() {
                _selectedLocation = position.target;
              });
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              color: kPrimaryColor,
              size: 40,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _selectedLocation != null ? _updateLocation : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.oxanium(color: kWhiteColor, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateLocation() async {
    try {
      controller.latitude.value = _selectedLocation!.latitude;
      controller.longitude.value = _selectedLocation!.longitude;
      Get.to(() => RepairEstimatesScreen());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update workshop location",
        snackPosition: SnackPosition.TOP,
        backgroundColor: kDangerColor,
        colorText: kWhiteColor,
      );
    }
  }
}
