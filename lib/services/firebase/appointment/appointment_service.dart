import 'dart:developer';

import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/model/Vendor/workshop_review.model.dart';
import 'package:car_fix_up/services/firebase/user/user_services.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createConfirmAppointment(Appointment appointment) async {
    try {
      await _firestore
          .collection("vendors")
          .doc(appointment.vendorUid)
          .collection("confirmed_appointments")
          .add(appointment.toMap());
    } catch (e) {
      throw e;
    }
  }

  //onHold Appointments
  Future<void> createOnHoldAppointment(Appointment appointment) async {
    try {
      await _firestore
          .collection("vendors")
          .doc(appointment.vendorUid)
          .collection("on_hold_appointments")
          .add(appointment.toMap());
    } catch (e) {
      throw e;
    }
  }

  Stream<List<Appointment>> getConfirmedAppointments() async* {
    final snapshot = _firestore
        .collection("vendors")
        .doc(_auth.currentUser?.uid)
        .collection("confirmed_appointments")
        .snapshots();
    yield* snapshot.map((event) => event.docs
        .map((doc) => Appointment.fromMap(doc.data(), doc.id))
        .toList());
    // try {
    //   final snapshot = await _firestore
    //       .collection("vendors")
    //       .doc(_auth.currentUser?.uid)
    //       .collection("confirmed_appointments")
    //       .get();
    //   return snapshot.docs
    //       .map((doc) => Appointment.fromMap(doc.data(), doc.id))
    //       .toList();
    // } catch (e) {
    //   throw e;
    // }
  }

  Stream<List<Appointment>> getOnHoldAppointments() async* {
    final snapshot = _firestore
        .collection("vendors")
        .doc(_auth.currentUser?.uid)
        .collection("on_hold_appointments")
        .snapshots();
    yield* snapshot.map((event) => event.docs
        .map((doc) => Appointment.fromMap(doc.data(), doc.id))
        .toList());
    // try {
    //   final snapshot = await _firestore
    //       .collection("vendors")
    //       .doc(_auth.currentUser?.uid)
    //       .collection("on_hold_appointments")
    //       .get();
    //   return snapshot.docs
    //       .map((doc) => Appointment.fromMap(doc.data(), doc.id))
    //       .toList();
    // } catch (e) {
    //   throw e;
    // }
  }

  Stream<List<Appointment>> getCompletedAppointments() async* {
    final snapshot = _firestore
        .collection("vendors")
        .doc(_auth.currentUser?.uid)
        .collection("completed_appointments")
        .snapshots();
    yield* snapshot.map((event) => event.docs
        .map((doc) => Appointment.fromMap(doc.data(), doc.id))
        .toList());
    // try {
    //   final snapshot = await _firestore
    //       .collection("vendors")
    //       .doc(_auth.currentUser?.uid)
    //       .collection("completed_appointments")
    //       .get();
    //   return snapshot.docs
    //       .map((doc) => Appointment.fromMap(doc.data(), doc.id))
    //       .toList();
    // } catch (e) {
    //   throw e;
    // }
  }

  Future<void> confirmTheOnHoldAppointment(Appointment appointmentId) async {
    try {
      final appointment = await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("on_hold_appointments")
          .doc(appointmentId.appointmentId)
          .get();
      await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("confirmed_appointments")
          .add(appointment.data()!);
      await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("on_hold_appointments")
          .doc(appointmentId.appointmentId)
          .delete();
      String deviceToken =
          await UserServices().getUserDeviceTokenByUid(appointmentId.userUid);
      log("deviceToken: $deviceToken");
      await PushNotification.sendNotification(
          deviceToken,
          "Appointment Confirmed",
          "Your appointment has been confirmed by the vendor", {
        "type": "appointment",
        "date": appointment.data()!["dateOfAppointment"],
        "time": appointment.data()!["timeSlot"],
      });
    } catch (e) {
      log("error: $e");
      throw e;
    }
  }

  void completeTheAppointment(String appointmentId) async {
    try {
      final appointment = await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("confirmed_appointments")
          .doc(appointmentId)
          .get();
      await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("completed_appointments")
          .add(appointment.data()!);
      await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("confirmed_appointments")
          .doc(appointmentId)
          .delete();
      String deviceToken = await UserServices()
          .getUserDeviceTokenByUid(appointment.data()!["userUid"]);
      log("deviceToken: $deviceToken");
      await PushNotification.sendNotification(
          deviceToken,
          "Appointment Completed",
          "Your appointment has been mark completed by the vendor", {
        "type": "appointment",
      });
    } catch (e) {
      log("error: $e");
      throw e;
    }
  }

  Future<List<Appointment>> getUserAllCorfirmedAppointments() async {
    VendorServices vendorServices = VendorServices();
    final List<String> vendorUids = await vendorServices.getAllVendorsUids();
    log("vendorUids: $vendorUids");
    List<Appointment> allAppointments = [];
    for (String vendorUid in vendorUids) {
      final snapshot = await _firestore
          .collection("vendors")
          .doc(vendorUid)
          .collection("confirmed_appointments")
          .where("userUid", isEqualTo: _auth.currentUser?.uid)
          .get();
      allAppointments.addAll(snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data(), doc.id))
          .toList());
    }
    return allAppointments;
  }

  Future<List<Appointment>> getUserAllRequestedAppointments() async {
    VendorServices vendorServices = VendorServices();
    final List<String> vendorUids = await vendorServices.getAllVendorsUids();
    log("vendorUids: $vendorUids");
    List<Appointment> allAppointments = [];
    for (String vendorUid in vendorUids) {
      final snapshot = await _firestore
          .collection("vendors")
          .doc(vendorUid)
          .collection("on_hold_appointments")
          .where("userUid", isEqualTo: _auth.currentUser?.uid)
          .get();
      allAppointments.addAll(snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data(), doc.id))
          .toList());
    }
    return allAppointments;
  }

  Future<List<Appointment>> getUserAllCompletedAppointments() async {
    VendorServices vendorServices = VendorServices();
    final List<String> vendorUids = await vendorServices.getAllVendorsUids();
    log("vendorUids: $vendorUids");
    List<Appointment> allAppointments = [];
    for (String vendorUid in vendorUids) {
      final snapshot = await _firestore
          .collection("vendors")
          .doc(vendorUid)
          .collection("completed_appointments")
          .where("userUid", isEqualTo: _auth.currentUser?.uid)
          .get();
      allAppointments.addAll(snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data(), doc.id))
          .toList());
    }
    return allAppointments;
  }

  Future<void> cancelTheAppointment(String appointmentId) async {
    try {
      //get all vendor uid first
      VendorServices vendorServices = VendorServices();
      final List<String> vendorUids = await vendorServices.getAllVendorsUids();
      for (String vendorUid in vendorUids) {
        final appointment = await _firestore
            .collection("vendors")
            .doc(vendorUid)
            .collection("on_hold_appointments")
            .doc(appointmentId)
            .get();
        if (appointment.exists) {
          await _firestore
              .collection("vendors")
              .doc(vendorUid)
              .collection("on_hold_appointments")
              .doc(appointmentId)
              .delete();
        }
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> giveReviewOfCompleted(
      Appointment appointment, double rating, String review) async {
    UserController userController = Get.find<UserController>();
    try {
      await _firestore
          .collection("vendors")
          .doc(appointment.vendorUid)
          .collection("completed_appointments")
          .doc(appointment.appointmentId)
          .update({
        "isReviewed": true,
      });
      //add review in vendor collection >> document (vendor uid)  >> then review array of Map (reviewer_name,rating,comment,appointment_docId)
      await _firestore.collection("vendors").doc(appointment.vendorUid).update({
        "reviews": FieldValue.arrayUnion([
          {
            "reviewer_name": userController.name,
            "rating": rating,
            "comment": review,
            "appointment_docId": appointment.appointmentId,
            "datePosted": DateTime.now().toString(),
          }
        ])
      });
    } catch (e) {
      throw e;
    }
  }

  Future<WorkshopReview> getTheReview(Appointment appointment) async {
    try {
      final snapshot = await _firestore
          .collection("vendors")
          .doc(appointment.vendorUid)
          .get();
      final Vendor vendor = Vendor.fromJson(snapshot.data()!);
      final WorkshopReview reviews = vendor.workshopReviews.firstWhere(
          (element) => element.appointmentDocId == appointment.appointmentId);
      return reviews;
    } catch (e) {
      throw e;
    }
  }
}
