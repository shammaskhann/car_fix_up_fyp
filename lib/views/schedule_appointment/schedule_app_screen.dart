import 'dart:developer';

import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduleAppointView extends StatefulWidget {
  final Vendor vendor;
  const ScheduleAppointView({required this.vendor, super.key});

  @override
  _ScheduleAppointViewState createState() => _ScheduleAppointViewState();
}

class _ScheduleAppointViewState extends State<ScheduleAppointView> {
  DateTime? selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    // Generate a list of past dates up to today
    List<DateTime> pastDates = [];
    DateTime now = DateTime.now();
    for (int i = 1; i <= 365; i++) {
      pastDates.add(now.subtract(Duration(days: i)));
    }

    // Generate a list of all Sundays within a year from today
    List<DateTime> sundays = [];
    for (int i = 0; i <= 365; i++) {
      DateTime date = now.add(Duration(days: i));
      if (date.weekday == DateTime.sunday) {
        sundays.add(date);
      }
    }

    // Combine past dates and Sundays
    List<DateTime> disabledDates = [...pastDates, ...sundays];

    // // Parse operational and close times
    // DateFormat timeFormat = DateFormat.jm();
    // DateTime operationalTime =
    //     timeFormat.parse(widget.vendor.workshop.operationalTime.trim());
    // DateTime closeTime =
    //     timeFormat.parse(widget.vendor.workshop.closeTime.trim());

    // // Generate time slots
    // List<DateTime> timeSlots = [];
    // DateTime currentTime = operationalTime;
    // while (currentTime.isBefore(closeTime)) {
    //   timeSlots.add(currentTime);
    //   currentTime = currentTime.add(Duration(minutes: 30));
    // }

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: kWhiteColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: 0.25.sh,
                  color: kBlackColor,
                  child: Center(
                    child: Text(
                      'Schedule Appointment',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Select a date',
                  style: GoogleFonts.oxanium(
                    fontSize: 16.sp,
                    color: kBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              EasyDateTimeLine(
                disabledDates: disabledDates,
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  // `selectedDate` the new date selected.
                  log(selectedDate.toString());
                },
                headerProps: const EasyHeaderProps(
                  showHeader: true,
                  centerHeader: true,
                  showSelectedDate: false,
                  monthPickerType: MonthPickerType.switcher,
                ),
                dayProps: const EasyDayProps(
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xffF0F0F0),
                    ),
                  ),
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff3371FF),
                          Color(0xff8426D6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Select a time',
                  style: GoogleFonts.oxanium(
                    fontSize: 16.sp,
                    color: kBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              //time Picker
              // Container(
              //   height: 50.h,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: timeSlots.length,
              //     itemBuilder: (context, index) {
              //       DateTime timeSlot = timeSlots[index];
              //       bool isSelected = selectedTimeSlot == timeSlot;
              //       return GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             selectedTimeSlot = timeSlot;
              //           });
              //         },
              //         child: Container(
              //           margin: EdgeInsets.symmetric(horizontal: 5.0),
              //           padding:
              //               EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              //           decoration: BoxDecoration(
              //             color: isSelected ? kPrimaryColor : kWhiteColor,
              //             borderRadius: BorderRadius.circular(8),
              //             border: Border.all(color: kPrimaryColor),
              //           ),
              //           child: Center(
              //             child: Text(
              //               timeFormat.format(timeSlot),
              //               style: TextStyle(
              //                 color: isSelected ? kWhiteColor : kPrimaryColor,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
