import 'dart:async';
import 'dart:developer';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateWorkshopLocationScreen extends StatefulWidget {
  const UpdateWorkshopLocationScreen({super.key});

  @override
  State<UpdateWorkshopLocationScreen> createState() =>
      _UpdateWorkshopLocationScreenState();
}

class _UpdateWorkshopLocationScreenState
    extends State<UpdateWorkshopLocationScreen> {
  LatLng? _selectedLocation;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Update Workshop Location',
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
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                  37.7749, -122.4194), // Default location (San Francisco)
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
                'Update Location',
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
      log('Updating location: $_selectedLocation');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('vendors').doc(uid).update({
        'workshop.loc.lat': _selectedLocation!.latitude,
        'workshop.loc.lng': _selectedLocation!.longitude,
      });
      Get.snackbar(
        "Success",
        "Workshop location updated successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: kWhiteColor,
      );
      Navigator.pop(context);
    } catch (e) {
      log(e.toString());
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
