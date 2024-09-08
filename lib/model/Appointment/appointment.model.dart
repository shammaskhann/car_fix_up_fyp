import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Appointment {
  final String appointmentId;
  final String userName;
  final String userUid;
  final String vendorUid;
  final String userCarPlate;
  final DateTime dateOfAppointment;
  final bool isReviewed;
  final String timeSlot;
  final bool isCanceled;
  final bool isMobileRepair;
  final LatLng? location;

  Appointment({
    required this.appointmentId,
    required this.userName,
    required this.userUid,
    required this.vendorUid,
    required this.userCarPlate,
    required this.dateOfAppointment,
    required this.isReviewed,
    required this.timeSlot,
    required this.isCanceled,
    required this.isMobileRepair,
    this.location,
  });

  // Convert a Firestore document to an Appointment object
  factory Appointment.fromMap(Map<String, dynamic> data, String documentId) {
    return Appointment(
      appointmentId: documentId,
      userName: data['userName'] ?? '',
      userUid: data['userUid'] ?? '',
      vendorUid: data['vendorUid'] ?? '',
      userCarPlate: data['userCarPlate'] ?? '',
      dateOfAppointment: (data['dateOfAppointment'] as Timestamp).toDate(),
      isReviewed: data['isReviewed'] ?? false,
      timeSlot: data['timeSlot'] ?? '',
      isCanceled: data['isCanceled'] ?? false,
      isMobileRepair: data['isMobileRepair'] ?? false,
      location: data['location'] != null
          ? LatLng(data['location']['latitude'], data['location']['longitude'])
          : null,
    );
  }

  // Convert an Appointment object to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userUid': userUid,
      'vendorUid': vendorUid,
      'userCarPlate': userCarPlate,
      'dateOfAppointment': dateOfAppointment,
      'isReviewed': isReviewed,
      'timeSlot': timeSlot,
      'isCanceled': isCanceled,
      'isMobileRepair': isMobileRepair,
      'location': location != null
          ? {
              'latitude': location!.latitude,
              'longitude': location!.longitude,
            }
          : null,
    };
  }
}
