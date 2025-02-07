import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/local-storage/localStorage.dart';
import 'package:car_fix_up/views/User/update_profile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late Future<Map<String, String?>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _getUserInfo();
  }

  Future<Map<String, String?>> _getUserInfo() async {
    final localStorageService = LocalStorageService();
    final name = await localStorageService.getName();
    final email = await localStorageService.getEmail();
    final contactNo = await localStorageService.getContactNo();
    final userType = await localStorageService.getUserType();
    return {
      'name': name,
      'email': email,
      'contactNo': contactNo,
      'userType': userType,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: BottomCurveClipper(),
              child: Stack(
                children: [
                  Container(
                    height: 0.25.sh,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kBlackColor, Colors.grey[800]!],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Profile',
                        style: GoogleFonts.oxanium(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.05.sh,
                    left: 14,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Map<String, String?>>(
                future: _userInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.hasData) {
                    final userInfo = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileDetail("Name", userInfo['name']),
                        _buildProfileDetail("Email", userInfo['email']),
                        _buildProfileDetail(
                            "Contact No", userInfo['contactNo']),
                        const SizedBox(height: 20),
                        _buildButton("Edit Profile", () async {
                          await Get.to(() => UpdateProfileScreen(
                              name: userInfo['name'] ?? "",
                              email: userInfo['email'] ?? "",
                              phone: userInfo['contactNo'] ?? ""));
                          setState(() {
                            _userInfoFuture = _getUserInfo();
                          });
                        }),
                        const SizedBox(height: 20),
                        _buildButton("Logout", () async {
                          ZegoUIKitPrebuiltCallInvitationService().uninit();
                          await LocalStorageService().clearAll();
                          await FirebaseAuth.instance.signOut();
                          Get.offAllNamed(RouteName.onboarding);
                        }),
                      ],
                    );
                  }
                  return const Center(
                    child: Text("No user information available"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.oxanium(
              color: kBlackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value ?? "N/A",
            style: GoogleFonts.oxanium(
              color: kGreyText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String title, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.oxanium(
                  color: kWhiteText,
                  fontSize: 0.04.sw,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: kWhiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
