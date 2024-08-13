// import 'dart:developer';

// import 'package:car_fix_up/model/Vendor/workshop.model.dart';
// import 'package:car_fix_up/model/Vendor/workshop_review.model.dart';

// class Vendor {
//   final String uid;
//   final String password;
//   final String phone;
//   final Workshop workshop;
//   final List<WorkshopReview> workshopReviews;
//   final String name;
//   final String userType;
//   final String email;
//   final String deviceToken;

//   Vendor({
//     required this.uid,
//     required this.password,
//     required this.phone,
//     required this.workshop,
//     required this.workshopReviews,
//     required this.name,
//     required this.userType,
//     required this.email,
//     required this.deviceToken,
//   });

//   factory Vendor.fromJson(Map<String, dynamic> json) {
//     log(json.toString());
//     return Vendor(
//       uid: json['uid'] ?? '',
//       password: json['password'] ?? '',
//       phone: json['phone'] ?? '',
//       workshop: Workshop.fromJson(json['workshop'] ?? {}),
//       workshopReviews: json['reviews'] != null
//           ? List<WorkshopReview>.from(
//               json['reviews'].map((x) => WorkshopReview.fromJson(x)))
//           : [],
//       name: json['name'] ?? '',
//       userType: json['userType'] ?? '',
//       email: json['email'] ?? '',
//       deviceToken: json['deviceToken'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'uid': uid,
//         'password': password,
//         'phone': phone,
//         'workshop': workshop.toJson(),
//         'reviews': List<dynamic>.from(workshopReviews.map((x) => x.toJson())),
//         'name': name,
//         'userType': userType,
//         'email': email,
//         'deviceToken': deviceToken,
//       };
// }
import 'dart:developer';

import 'package:car_fix_up/model/Vendor/workshop.model.dart';
import 'package:car_fix_up/model/Vendor/workshop_review.model.dart';

class Vendor {
  final String uid;
  final String password;
  final String phone;
  final Workshop workshop;
  final List<WorkshopReview> workshopReviews;
  final String name;
  final String userType;
  final String email;
  final String deviceToken;

  Vendor({
    required this.uid,
    required this.password,
    required this.phone,
    required this.workshop,
    required this.workshopReviews,
    required this.name,
    required this.userType,
    required this.email,
    required this.deviceToken,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Vendor(
      uid: json['uid'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      workshop: json['workshop'] != null
          ? Workshop.fromJson(json['workshop'])
          : Workshop(
              name: '',
              id: '',
              desc: '',
              area: '',
              city: '',
              imageUrl: '',
              loc: null,
              operationalTime: '',
              closeTime: '',
            ),
      workshopReviews: json['reviews'] != null
          ? List<WorkshopReview>.from(
              json['reviews'].map((x) => WorkshopReview.fromJson(x)))
          : [],
      name: json['name'] ?? '',
      userType: json['userType'] ?? '',
      email: json['email'] ?? '',
      deviceToken: json['deviceToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'password': password,
        'phone': phone,
        'workshop': workshop.toJson(),
        'reviews': List<dynamic>.from(workshopReviews.map((x) => x.toJson())),
        'name': name,
        'userType': userType,
        'email': email,
        'deviceToken': deviceToken,
      };
}
