import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> confirmTheOnHoldAppointment(String appointmentId) async {
    try {
      final appointment = await _firestore
          .collection("vendors")
          .doc(_auth.currentUser?.uid)
          .collection("on_hold_appointments")
          .doc(appointmentId)
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
          .doc(appointmentId)
          .delete();
    } catch (e) {
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
    } catch (e) {
      throw e;
    }
  }

  Future<List<Appointment>> getUserAllCorfirmedAppointments() async {
    VendorServices vendorServices = VendorServices();
    final List<String> vendorUids = await vendorServices.getAllVendorsUids();
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
}
