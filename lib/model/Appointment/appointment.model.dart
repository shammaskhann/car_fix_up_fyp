import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointmentId;
  final String userName;
  final String userUid;
  final String vendorUid;
  final String userCarPlate;
  final DateTime dateOfAppointment;
  final String timeSlot;
  final bool isCanceled;

  Appointment({
    required this.appointmentId,
    required this.userName,
    required this.userUid,
    required this.vendorUid,
    required this.userCarPlate,
    required this.dateOfAppointment,
    required this.timeSlot,
    required this.isCanceled,
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
      timeSlot: data['timeSlot'] ?? '',
      isCanceled: data['isCanceled'] ?? false,
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
      'timeSlot': timeSlot,
      'isCanceled': isCanceled,
    };
  }
}
