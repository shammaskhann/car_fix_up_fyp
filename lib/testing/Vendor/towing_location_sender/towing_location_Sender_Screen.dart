import 'dart:async';

import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/towing_rides/towing_ride_servie.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:developer';

class LocationSenderScreen extends StatefulWidget {
  final String requestId;
  final GeoPoint pickup;
  const LocationSenderScreen(
      {required this.requestId, required this.pickup, super.key});
  @override
  _LocationSenderScreenState createState() => _LocationSenderScreenState();
}

class _LocationSenderScreenState extends State<LocationSenderScreen> {
  late Location location;
  late LocationData currentLocation;
  late Stream<LocationData> locationStream;
  bool isCloseToLocation = false;
  final mapController = Completer<GoogleMapController>();
  @override
  void initState() {
    super.initState();
    log('Request ID: ${widget.requestId}');
    location = new Location();
    startLocationStream();
  }

  void startLocationStream() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationStream = location.onLocationChanged;
    locationStream.listen((LocationData currentLocation) {
      log('Location: ${currentLocation.latitude}, ${currentLocation.longitude}');
      FirebaseFirestore.instance
          .collection('towing_requests')
          .doc(
            widget.requestId,
          )
          .update({
        'active_location':
            GeoPoint(currentLocation.latitude!, currentLocation.longitude!)
      });
      mapController.future.then((controller) {
        controller.animateCamera(CameraUpdate.newLatLng(
            LatLng(currentLocation.latitude!, currentLocation.longitude!)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
          'Towing Ride',
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
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.3308401, 71.247499),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
            myLocationEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId('pickup'),
                position:
                    LatLng(widget.pickup.latitude, widget.pickup.longitude),
                infoWindow: const InfoWindow(title: 'Pickup Location'),
                icon: BitmapDescriptor.defaultMarker,
              ),
            },
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
              bottom: 0.05.sh,
              right: 0.0,
              left: 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: CustomButton(
                    borderRadius: 15,
                    text: "Mark As Completed",
                    onPressed: () {
                      TowingRideService()
                          .changeTowingStatusToCompleted(widget.requestId);
                      Get.back();
                    },
                    textColor: kWhiteText,
                    buttonColor: kPrimaryColor),
              ))
        ],
      ),
    );
  }
}
