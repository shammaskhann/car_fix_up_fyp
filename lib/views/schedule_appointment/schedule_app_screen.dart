import 'dart:developer';

import 'package:car_fix_up/controller/appointment_controller.dart';
import 'package:car_fix_up/model/Appointment/appointment.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/firebase/appointment/appointment_service.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:car_fix_up/shared/button.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:intl/intl.dart';
import 'package:time_slot/time_slot_from_list.dart';

import '../../controller/user_controller.dart';

class ScheduleAppointView extends StatefulWidget {
  final Vendor vendor;
  const ScheduleAppointView({required this.vendor, super.key});

  @override
  _ScheduleAppointViewState createState() => _ScheduleAppointViewState();
}

class _ScheduleAppointViewState extends State<ScheduleAppointView> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedTime;
  List<DateTime> timeSlots = [];

  @override
  void initState() {
    super.initState();
    generateTimeSlots(DateTime.now());
  }

  void generateTimeSlots(DateTime date) {
    List<DateTime> slots = [];
    DateTime startTime = DateTime(date.year, date.month, date.day, 10, 0);
    DateTime endTime = DateTime(date.year, date.month, date.day, 16, 30);

    while (startTime.isBefore(endTime)) {
      slots.add(startTime);
      startTime = startTime.add(const Duration(minutes: 30));
    }

    setState(() {
      timeSlots = slots;
    });
  }

  List<DateTime> getDisabledDates() {
    List<DateTime> pastDates = [];
    DateTime now = DateTime.now();
    for (int i = 1; i <= 365; i++) {
      pastDates.add(now.subtract(Duration(days: i)));
    }

    List<DateTime> sundays = [];
    for (int i = 0; i <= 365; i++) {
      DateTime date = now.add(Duration(days: i));
      if (date.weekday == DateTime.sunday) {
        sundays.add(date);
      }
    }

    List<DateTime> futureDatesBeyondTwoWeeks = [];
    for (int i = 15; i <= 365; i++) {
      futureDatesBeyondTwoWeeks.add(now.add(Duration(days: i)));
    }

    return [...pastDates, ...sundays, ...futureDatesBeyondTwoWeeks];
  }

  @override
  Widget build(BuildContext context) {
    AppointmentScheduleController controller =
        Get.put(AppointmentScheduleController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1.sh,
          width: 1.sw,
          color: kWhiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: 0.25.sh,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [kBlackColor, Colors.grey[800]!]),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: kWhiteColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: kWhiteColor,
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => NotificationView(),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          'Schedule Appointment',
                          style: GoogleFonts.oxanium(
                            fontSize: 24.sp,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'SELECT DATE & TIME',
                  style: GoogleFonts.oxanium(
                    fontSize: 18.sp,
                    color: kBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              EasyDateTimeLine(
                disabledDates: getDisabledDates(),
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  log(selectedDate.toString());
                  setState(() {
                    this.selectedDate = selectedDate;
                  });
                  generateTimeSlots(selectedDate);
                },
                headerProps: const EasyHeaderProps(
                  showHeader: true,
                  centerHeader: true,
                  showSelectedDate: false,
                  monthPickerType: MonthPickerType.switcher,
                ),
                dayProps: EasyDayProps(
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: const DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffF7C911),
                          Color(0xffF7C911),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TimesSlotGridViewFromList(
                  locale: "en",
                  initTime: selectedTime ?? DateTime.now(),
                  crossAxisCount: 4,
                  unSelectedColor: Colors.grey.shade300,
                  selectedColor: kPrimaryColor,
                  listDates: timeSlots,
                  onChange: (value) {
                    log(value.toString());
                    setState(() {
                      selectedTime = value;
                    });
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomButton(
                  borderRadius: 10,
                  text: 'Request Appointment',
                  onPressed: () {
                    if (selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a time slot.'),
                        ),
                      );
                      return;
                    }
                    DateTime finalDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                    log(finalDateTime.toString());
                    log("data ${DateFormat('yyyy-MM-dd').format(finalDateTime)} , ${DateFormat('HH:mm').format(finalDateTime)}");
                    controller.requestAppointment(widget.vendor.deviceToken,
                        widget.vendor.uid, finalDateTime, "1234");

                    // PushNotification.sendNotification(
                    // widget.vendor.deviceToken,
                    // "New Appointment Request",
                    // "You have a new appointment request on ${DateFormat('yyyy-MM-dd').format(finalDateTime)} at ${DateFormat('HH:mm').format(finalDateTime)}. Please review and accept or reject the appointment.",
                    // {
                    //   "type": "appointment",
                    //   "date":
                    //       DateFormat('yyyy-MM-dd').format(finalDateTime),
                    //   "time": DateFormat('HH:mm').format(finalDateTime),
                    // });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HomeView(),
                    //   ),
                    // );
                  },
                  textColor: kWhiteText,
                  buttonColor: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
