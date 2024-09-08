import 'dart:developer';

import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/services/firebase/user/user_services.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:intl/intl.dart';

class PushNotificationController {
  static void sendReviewNotification(
      Appointment appointment, double rating, String review) async {
    try {
      Vendor vendor =
          await VendorServices().getVendorByUid(appointment.vendorUid);
      PushNotification.sendNotification(
          vendor.deviceToken,
          "New Review",
          "You have a new review from ${appointment.userName} with rating $rating. Review: $review",
          {"type": "review", "vendor": vendor.toJson().toString()});
    } catch (e) {
      log(e.toString());
    }
  }

  static void sendAppointmentNotification(
      String deviceToken, DateTime finalDateTime) {
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

  static void sendAppointmentConfirmationNotification(
      String userUid, DateTime dateOfAppointment, String timeSlot) async {
    String deviceToken = await UserServices().getUserDeviceTokenByUid(userUid);
    PushNotification.sendNotification(
        deviceToken,
        "Appointment Confirmed",
        "Your appointment request on ${DateFormat('yyyy-MM-dd').format(dateOfAppointment)} at $timeSlot has been confirmed.",
        {
          "type": "appointment",
          "date": DateFormat('yyyy-MM-dd').format(dateOfAppointment),
          "time": timeSlot,
        });
    // PushNotification.sendNotification(
    //     deviceToken,
    //     "Appointment Confirmed",
    //     "Your appointment request on ${DateFormat('yyyy-MM-dd').format(finalDateTime)} at ${DateFormat('HH:mm').format(finalDateTime)} has been confirmed.",
    //     {
    //       "type": "appointment",
    //       "date": DateFormat('yyyy-MM-dd').format(finalDateTime),
    //       "time": DateFormat('HH:mm').format(finalDateTime),
    //     });
  }

  static void sendAppointmentCancellationNotification(
      String userUid, DateTime dateOfAppointment, String timeSlot) async {
    String deviceToken = await UserServices().getUserDeviceTokenByUid(userUid);
    PushNotification.sendNotification(
        deviceToken,
        "Appointment Cancelled",
        "Your appointment request on ${DateFormat('yyyy-MM-dd').format(dateOfAppointment)} at $timeSlot has been cancelled.",
        {
          "type": "appointment",
          "date": DateFormat('yyyy-MM-dd').format(dateOfAppointment),
          "time": timeSlot,
        });
  }

  static void sendAppointmentCompletionNotification(
      String userUid, DateTime dateOfAppointment, String timeSlot) async {
    String deviceToken = await UserServices().getUserDeviceTokenByUid(userUid);
    PushNotification.sendNotification(
        deviceToken,
        "Appointment Completed",
        "Your appointment request on ${DateFormat('yyyy-MM-dd').format(dateOfAppointment)} at $timeSlot has been completed.",
        {
          "type": "appointment",
          "date": DateFormat('yyyy-MM-dd').format(dateOfAppointment),
          "time": timeSlot,
        });
  }
}
