// import 'package:car_fix_up/views/User/home/screen/towing_service_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';

// class LocationAllowScreeen extends StatelessWidget {
//   bool service;
//   final Map<String, double> userLatLng;
//   LocationAllowScreeen(
//       {super.key, required this.userLatLng, required this.service});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child: Image.asset(
//                 "assets/images/no_location.jpg",
//                 // height: 200,
//               ),
//             ),
//             Center(
//               child: service
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                           Text(
//                             "Allow Location service or enable service",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                                 fontSize: 20),
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 var checkPermission =
//                                     await Location().requestService();
//                                 if (checkPermission) {
//                                   Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (_) => TowingScreenServices(
//                                                 userLatLng: userLatLng,
//                                               )));
//                                 }
//                               },
//                               child: const Text("Enable Service"))
//                         ])
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                           Text(
//                             "Allow Location permission from settings",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                                 fontSize: 20),
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 var checkPermission = await GeolocatorPlatform
//                                     .instance
//                                     .openAppSettings()
//                                     .then((checkPermission) {
//                                   print(
//                                       "permission from service is $checkPermission");
//                                   if (checkPermission) {
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) =>
//                                                 TowingScreenServices(
//                                                   userLatLng: userLatLng,
//                                                 )));
//                                   }
//                                 });
//                               },
//                               child: const Text("Allow Permission"))
//                         ]),
//             ),
//             Expanded(child: Container())
//           ],
//         ),
//       ),
//     );
//   }
// }
