// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:car_fix_up/views/User/home/home_view.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class TowingRideScreen extends StatefulWidget {
//   final LatLng userLocation;
//   const TowingRideScreen({
//     required this.userLocation,
//     super.key,
//   });

//   @override
//   _TowingRideScreenState createState() => _TowingRideScreenState();
// }

// class _TowingRideScreenState extends State<TowingRideScreen> {
//   Completer<GoogleMapController> _controller = Completer();
//   GoogleMapController? newMapController;
//   Set<Marker> _markers = {};
//   StreamSubscription<DocumentSnapshot>? locationSubscription;

//   @override
//   void initState() {
//     super.initState();
//     subscribeToLocationUpdates();
//   }

//   void subscribeToLocationUpdates() {
//     locationSubscription = FirebaseFirestore.instance
//         .collection('towing_rides')
//         .doc(
//             'cKD8bJ50Q8W4JMNz_i-U1r:APA91bHYg9qGa3X-8U3EXI0kUk-kyD0nurWHYtUwYtCZoIt_pKZz3Z8qfqsXB8aizackMQ7IsrUZRDi4Y1z5-n7es2FNO85UrlacBgQ03lazhRldqXgGyPfQYBKZRlJUn5qLrhmIK0JO')
//         .snapshots()
//         .listen((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         GeoPoint activeLocation = documentSnapshot['active_location'];
//         updateMarker(LatLng(activeLocation.latitude, activeLocation.longitude));
//       }
//     });
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   void updateMarker(LatLng latLng) async {
//     final Uint8List markerIcon =
//         await getBytesFromAsset('assets/images/car.png', 100);
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId('towTruck'),
//           position: latLng,
//           // icon: BitmapDescriptor.fromAsset('assets/images/car.png'),
//           icon: BitmapDescriptor.fromBytes(markerIcon),
//         ),
//       );
//     });
//     newMapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: latLng,
//           zoom: 14.0,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     locationSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 0.19.sh),
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(0.0, 0.0),
//                   zoom: 8.0,
//                 ),
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//                 mapType: MapType.normal,
//                 markers: _markers,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                   newMapController = controller;
//                 },
//               ),
//             ),
//             ClipPath(
//               clipper: BottomCurveClipper(),
//               child: Container(
//                 height: 0.25.sh,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.black, Colors.grey[800]!],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(top: 0.05.sh),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back_ios),
//                             onPressed: () {
//                               Get.back();
//                             },
//                             color: Colors.white,
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.person),
//                             onPressed: () {},
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 0.02.sh),
//                       child: Text(
//                         "Towing Services",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0.05.sh,
//               right: 0.0,
//               left: 0.0,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: Text("Request Towing"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/towing_rides/towing_ride_servie.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:developer' as dev;

class TowingRideScreen extends StatefulWidget {
  final LatLng userLocation;
  final String requestId;

  const TowingRideScreen({
    required this.userLocation,
    required this.requestId,
    super.key,
  });

  @override
  _TowingRideScreenState createState() => _TowingRideScreenState();
}

class _TowingRideScreenState extends State<TowingRideScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newMapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  StreamSubscription<DocumentSnapshot>? locationSubscription;
  bool isCloseToLocation = false;
  String? status;

  @override
  void initState() {
    dev.log("Page Called: TowingRideScreen");
    super.initState();
    addPickupMarker();
    subscribeToLocationUpdates();
  }

  void addPickupMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('pickupLocation'),
          position: widget.userLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void subscribeToLocationUpdates() {
    locationSubscription = FirebaseFirestore.instance
        .collection('towing_requests')
        .doc(
          widget.requestId,
        )
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        GeoPoint activeLocation = documentSnapshot['active_location'];
        status = documentSnapshot['status'];
        LatLng towTruckLocation =
            LatLng(activeLocation.latitude, activeLocation.longitude);
        //drawRoute(towTruckLocation);
        updateTowTruckMarker(towTruckLocation);

        checkProximity(towTruckLocation, widget.userLocation);
      }
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void updateTowTruckMarker(LatLng latLng) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/tow_truck.png', 100);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('towTruck'),
          position: latLng,

          // ignore: deprecated_member_use
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
    });
    newMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 16.0,
        ),
      ),
    );
  }

  // void drawRoute(LatLng towTruckLocation) async {
  //   String googleAPIKey = 'AIzaSyBz4XY4fieOWwYCOsMklNXJh2li7GL2DCY';
  //   String url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=${towTruckLocation.latitude},${towTruckLocation.longitude}&destination=${widget.userLocation.latitude},${widget.userLocation.longitude}&key=${googleAPIKey}';

  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     if ((data['routes'] as List).isNotEmpty) {
  //       Map<String, dynamic> route = data['routes'][0];
  //       PolylineResult result =
  //           PolylineResult.fromJson(route['overview_polyline']);
  //       setState(() {
  //         _polylines.add(
  //           Polyline(
  //             polylineId: PolylineId('route'),
  //             points: result.points,
  //             color: Colors.blue,
  //             width: 5,
  //           ),
  //         );
  //       });
  //     }
  //   }
  // }

  void checkProximity(LatLng towTruckLocation, LatLng userLocation) {
    dev.log('Tow Truck Location: $towTruckLocation');
    dev.log('User Location: $userLocation');
    double distance = calculateDistance(
        towTruckLocation.latitude,
        towTruckLocation.longitude,
        userLocation.latitude,
        userLocation.longitude);
    dev.log('Distance: $distance');
    if (distance <= 300.0) {
      // Distance in meters
      setState(() {
        isCloseToLocation = true;
      });
    } else {
      setState(() {
        isCloseToLocation = false;
      });
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Radius of the Earth in meters
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.19.sh),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.userLocation,
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                markers: _markers,
                polylines: _polylines,
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
                    colors: [Colors.black, Colors.grey[800]!],
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
                        // style: TextStyle(
                        //   color: Colors.white,
                        //   fontSize: 20.sp,
                        //   fontWeight: FontWeight.bold,
                        // ),
                        style: GoogleFonts.oxanium(
                          color: kWhiteColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isCloseToLocation && (status == "accepted"))
              Positioned(
                bottom: 0.05.sh,
                right: 0.0,
                left: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: CustomButton(
                    onPressed: () {
                      // Perform action when user is close to location
                      TowingRideService().changeTowingStatusToInProgress(
                        widget.requestId,
                      );
                    },
                    text: "Confirm Arrival",
                    buttonColor: kPrimaryColor,
                    textColor: kWhiteColor,
                    borderRadius: 10.0,
                  ),
                ),
              ),
            if (status == "in_progress")
              Positioned(
                bottom: 0.05.sh,
                right: 0.0,
                left: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: CustomButton(
                    onPressed: () {},
                    text: "Ride in Progress",
                    buttonColor: kPrimaryColor,
                    textColor: kWhiteColor,
                    borderRadius: 10.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PolylineResult {
  final List<LatLng> points;

  PolylineResult({required this.points});

  factory PolylineResult.fromJson(Map<String, dynamic> json) {
    return PolylineResult(
      points: decodePolyline(json['points']),
    );
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }

    return poly;
  }
}
