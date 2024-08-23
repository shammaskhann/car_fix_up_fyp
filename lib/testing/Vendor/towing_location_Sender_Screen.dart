import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:developer';

class LocationSenderScreen extends StatefulWidget {
  const LocationSenderScreen({super.key});
  @override
  _LocationSenderScreenState createState() => _LocationSenderScreenState();
}

class _LocationSenderScreenState extends State<LocationSenderScreen> {
  late Location location;
  late LocationData currentLocation;
  late Stream<LocationData> locationStream;
  final mapController = Completer<GoogleMapController>();
  @override
  void initState() {
    super.initState();
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
          .collection('towing_rides')
          .doc(
              'cKD8bJ50Q8W4JMNz_i-U1r:APA91bHYg9qGa3X-8U3EXI0kUk-kyD0nurWHYtUwYtCZoIt_pKZz3Z8qfqsXB8aizackMQ7IsrUZRDi4Y1z5-n7es2FNO85UrlacBgQ03lazhRldqXgGyPfQYBKZRlJUn5qLrhmIK0JO')
          .set({
        'pickup': GeoPoint(30.3308401, 71.247499),
        'pickup_name': 'Your Pickup Name',
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
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(30.3308401, 71.247499),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        compassEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
