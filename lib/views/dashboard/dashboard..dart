import 'dart:io';

import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/chat/chat_screen.dart';
import 'package:car_fix_up/views/dashboard/controller/dashboard_controller.dart';
import 'package:car_fix_up/views/home/home_view.dart';
import 'package:car_fix_up/views/workshop/workshop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.put(DashboardController());
    final PageController _pageController = PageController();

    return WillPopScope(
        onWillPop: () async {
          if (dashboardController.currentIndex.value == 0) {
            return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor: kPrimaryColor,
                      title: Text(
                        'Are you sure?',
                        style: GoogleFonts.oxanium(
                            color: kBlackColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      contentTextStyle: GoogleFonts.oxanium(
                          color: kBlackColor, fontSize: 16.sp),
                      content: const Text('Do you want to exit an App'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'No',
                              style: GoogleFonts.oxanium(
                                  color: kBlackColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => exit(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Yes',
                              style: GoogleFonts.oxanium(
                                  color: kBlackColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ));
          } else {
            dashboardController.currentIndex.value = 0;
            return false;
          }
        },
        child: Scaffold(
          backgroundColor: kWhiteColor,
          drawer: Drawer(
            backgroundColor: kBlackColor.withOpacity(0.9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Text(
                      'Car Fix Up',
                      style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Image.asset(kSideMenuBg,
                        fit: BoxFit.cover, width: 1.sw, height: 1.sh),
                    Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.home_outlined,
                            color: kWhiteColor,
                          ),
                          title: Text(
                            'Home',
                            style: GoogleFonts.oxanium(
                                color: kWhiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            dashboardController.currentIndex.value = 0;
                            _pageController.jumpToPage(0);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.schedule_rounded,
                            color: kWhiteColor,
                          ),
                          title: Text(
                            'Schedule',
                            style: GoogleFonts.oxanium(
                                color: kWhiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            dashboardController.currentIndex.value = 1;
                            _pageController.jumpToPage(1);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.car_repair,
                            color: kWhiteColor,
                          ),
                          title: Text(
                            'Workshop',
                            style: GoogleFonts.oxanium(
                                color: kWhiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            dashboardController.currentIndex.value = 2;
                            _pageController.jumpToPage(2);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.person_outline,
                            color: kWhiteColor,
                          ),
                          title: Text(
                            'Profile',
                            style: GoogleFonts.oxanium(
                                color: kWhiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            dashboardController.currentIndex.value = 3;
                            _pageController.jumpToPage(3);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ],
                )),
              ],
            ),
          ),
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  dashboardController.changeIndex(index);
                },
                children: const [
                  HomeView(),
                  ChatView(),
                  WorkshopView(),
                  ChatView()
                ],
              ),
              // Custom floating bottom bar with animated page indicator
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 50.h,
                      width: 1.sh,
                      decoration: BoxDecoration(
                        color: kBlackColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: kBlackColor.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNavItem(
                                  icon: Icons.home_outlined,
                                  index: 0,
                                  controller: dashboardController,
                                  pageController: _pageController),
                              _buildNavItem(
                                  icon: Icons.schedule_rounded,
                                  index: 1,
                                  controller: dashboardController,
                                  pageController: _pageController),
                              _buildNavItem(
                                  icon: Icons.car_repair,
                                  index: 2,
                                  controller: dashboardController,
                                  pageController: _pageController),
                              _buildNavItem(
                                  icon: Icons.person_outline,
                                  index: 3,
                                  controller: dashboardController,
                                  pageController: _pageController),
                            ],
                          )),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget _buildNavItem(
      {required IconData icon,
      required int index,
      required DashboardController controller,
      required PageController pageController}) {
    return InkWell(
      onTap: () {
        pageController.jumpToPage(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: controller.currentIndex.value == index
                ? kPrimaryColor
                : kWhiteColor,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 5,
            width: controller.currentIndex.value == index ? 20 : 0,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ],
      ),
    );
  }
}
