import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/testing/Vendor/home/Vendor_Home.dart';
import 'package:car_fix_up/testing/Vendor/towing_location_sender/towing_location_Sender_Screen.dart';
import 'package:car_fix_up/testing/Vendor/towing_req_Screen.dart/towting_req_screen.dart';
import 'package:car_fix_up/testing/Vendor/vendorProfile/vendor_profile_Screen.dart';
import 'package:car_fix_up/views/User/chat/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorDashBoardScreen extends StatefulWidget {
  const VendorDashBoardScreen({super.key});

  @override
  State<VendorDashBoardScreen> createState() => _VendorDashBoardScreenState();
}

class _VendorDashBoardScreenState extends State<VendorDashBoardScreen> {
  final PageController _pageController = PageController();
  final RxInt _currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _currentIndex.value = index;
            },
            children: const [
              VendorHomeview(),
              ChatListView(),
              TowingReqScreen(),
              // LocationSenderScreen(),
              ProfileScreen(),
            ],
          ),
          BottomNavBar(
            pageController: _pageController,
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final PageController pageController;
  final RxInt currentIndex;

  BottomNavBar({required this.pageController, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 50.h,
          width: 1.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlackColor, Colors.grey[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: -2,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                      icon: kScheduledIcon,
                      index: 0,
                      currentIndex: currentIndex,
                      pageController: pageController),
                  _buildNavItem(
                      icon: kChatIcon,
                      index: 1,
                      currentIndex: currentIndex,
                      pageController: pageController),
                  _buildNavItem(
                      icon: kdignosticIcon,
                      index: 2,
                      currentIndex: currentIndex,
                      pageController: pageController),
                  _buildNavItem(
                      icon: kProfileIcon,
                      index: 3,
                      currentIndex: currentIndex,
                      pageController: pageController),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required String icon,
      required int index,
      required RxInt currentIndex,
      required PageController pageController}) {
    return InkWell(
      onTap: () {
        pageController.jumpToPage(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 30,
            width: 30,
            color: currentIndex.value == index ? kPrimaryColor : kWhiteColor,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 5,
            width: currentIndex.value == index ? 20 : 0,
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
