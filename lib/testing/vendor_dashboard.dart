import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'dart:developer';

class LocationSenderScreen extends StatefulWidget {
  @override
  _LocationSenderScreenState createState() => _LocationSenderScreenState();
}

class _LocationSenderScreenState extends State<LocationSenderScreen> {
  late Location location;
  late LocationData currentLocation;
  late Stream<LocationData> locationStream;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Location'),
      ),
      body: Center(
        child: Text('Sending location to Firestore...'),
      ),
    );
  }
}
