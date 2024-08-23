import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/firebase/appointment/appointment_service.dart';
import 'user_controller.dart';

class AppointmentScheduleController extends GetxController {
  RxBool isLoading = false.obs;
  final auth = FirebaseAuth.instance.currentUser;
  AppointmentService _appointmentService = AppointmentService();
  UserController _userController = Get.find<UserController>();

  void requestAppointment(String deviceToken, String vendorUid,
      DateTime finalDateTime, String carPlate) async {
    await _appointmentService.createOnHoldAppointment(
      Appointment(
        appointmentId: '',
        userName: _userController.name,
        userUid: auth!.uid,
        vendorUid: vendorUid,
        userCarPlate: carPlate,
        dateOfAppointment: finalDateTime,
        timeSlot: DateFormat('HH:mm').format(finalDateTime),
        isCanceled: false,
      ),
    );
    PushNotification.sendNotification(
        deviceToken,
        "New Appointment Request",
        "You have a new appointment request on ${DateFormat('yyyy-MM-dd').format(finalDateTime)} at ${DateFormat('HH:mm').format(finalDateTime)}. Please review and accept or reject the appointment.",
        {
          "type": "appointment",
          "date": DateFormat('yyyy-MM-dd').format(finalDateTime),
          "time": DateFormat('HH:mm').format(finalDateTime),
        });
  }

  Stream<List<Appointment>> getOnHoldAppointments() {
    return _appointmentService.getOnHoldAppointments();
  }

  void confirmAppointment(Appointment appointment) async {
    isLoading.value = true;
    await _appointmentService.confirmTheOnHoldAppointment(appointment);
    isLoading.value = false;
  }

  Stream<List<Appointment>> getConfirmedAppointments() {
    return _appointmentService.getConfirmedAppointments();
  }

  Stream<List<Appointment>> getCompletedAppointments() {
    return _appointmentService.getCompletedAppointments();
  }

  void completeTheAppointment(String appointmentId) {
    _appointmentService.completeTheAppointment(appointmentId);
  }

  Future<List<Appointment>> getUserOnHoldAppointments() async {
    return await _appointmentService.getUserAllRequestedAppointments();
  }

  Future<List<Appointment>> getUserConfirmAppointments() async {
    return await _appointmentService.getUserAllCorfirmedAppointments();
  }

  Future<List<Appointment>> getUserCompletedAppointments() async {
    return await _appointmentService.getUserAllCompletedAppointments();
  }
}
