import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/testing/Vendor/towing_location_sender/towing_location_Sender_Screen.dart';
import 'package:car_fix_up/testing/Vendor/vendor_chat_list/vendor_chatList_screen.dart';
import 'package:car_fix_up/testing/vendor_dashboard.dart';
import 'package:car_fix_up/views/User/auth/login_view.dart';
import 'package:car_fix_up/views/User/auth/signup_view.dart';
import 'package:car_fix_up/views/User/chat/chat_list_screen.dart';
import 'package:car_fix_up/views/User/chat/chat_screen.dart';
import 'package:car_fix_up/views/User/dashboard/dashboard..dart';
import 'package:car_fix_up/views/User/home/screen/live-dignostic_screen/live-dignostic.dart';
import 'package:car_fix_up/views/User/home/screen/remote_repair_screen/remote_repair_screen.dart';
import 'package:car_fix_up/views/User/home/screen/remote_repair_screen/workshopListSelect.dart';
import 'package:car_fix_up/views/User/home/screen/repair_estimate_screen/repair_est_result.dart';
import 'package:car_fix_up/views/User/home/screen/repair_estimate_screen/repair_est_screen.dart';
import 'package:car_fix_up/views/User/home/screen/repair_estimate_screen/workshops_list_est.dart';
import 'package:car_fix_up/views/components/onBoarding_screen.dart';
import 'package:car_fix_up/views/components/splash_screen.dart';
import 'package:car_fix_up/views/User/home/home_view.dart';
import 'package:car_fix_up/views/User/sos-video-call/sos_video_call_screen.dart';
import 'package:car_fix_up/views/components/vendor_profile.dart';
import 'package:car_fix_up/views/schedule_appointment/schedule_app_screen.dart';
import 'package:get/get.dart';
import 'package:googleapis/gkebackup/v1.dart';

class AppRoutes {
  static List<GetPage> appRoute() {
    return [
      GetPage(
        name: RouteName.splash,
        page: (() => const SplashView()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.onboarding,
        page: (() => const OnboardingScreen()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.dashboard,
        page: (() => const DashboardView()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.login,
        page: (() => const LoginView()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.signup,
        page: (() => const SignupView()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.home,
        page: (() => const HomeView()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.videoCall,
        page: (() => SosVideoCalScreem(
              callId: Get.arguments,
            )),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.chat,
        page: () => ChatView(
          uid: Get.arguments["uid"],
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.vendorProfile,
        page: (() => VendorProfile(
              vendor: Get.arguments,
            )),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.liveDignostic,
        page: (() => const LiveDignosticView()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),

      //testing screen
      GetPage(
        name: RouteName.liveLocScreen,
        page: (() => const LocationSenderScreen()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.vendorsDashboard,
        page: (() => const VendorDashBoardScreen()),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.vendorChatScreen,
        page: () => const VendorChatListScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.scheduleAppoint,
        page: () => ScheduleAppointView(
          vendor: Get.arguments['vendor'],
          isMobileRepair: Get.arguments['isMobileRepair'],
          loc: Get.arguments['loc'],
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.repairEstimate,
        page: () => RepairEstScreen(
          vendor: Get.arguments,
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.remoteRepair,
        page: () => const RemoteRepairScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.repairEstResult,
        page: () => RepairEstResultScreen(
          vendorUid: Get.arguments["vendorUid"],
          selectedEstimates: Get.arguments["selectedEstimates"],
          totalCost: Get.arguments["totalCost"],
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.repairEstWorkshopList,
        page: () => const WorkshopsListEstScreem(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: RouteName.remoteRepairWorkshopList,
        page: () => Workshoplistselect(
          Get.arguments,
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ];
  }
}

class RouteName {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String videoCall = '/video-call';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String vendorProfile = '/vendor-profile';
  static const String liveDignostic = '/live-dignostic';
  static const String repairEstimate = '/repair-estimate';
  static const String remoteRepair = '/remote-repair';
  static const String scheduleAppoint = '/schedule-appoint';
  static const String repairEstResult = "/repair-estimate-result";
  static const String repairEstWorkshopList = '/repair-est-workshop-list';
  static const String remoteRepairWorkshopList = '/remote-repair-workshop-list';
  //testing screen
  static const String vendorsDashboard = '/vendors-dashboard';
  static const String liveLocScreen = '/live-loc-screen';
  static const String vendorChatScreen = '/vendor-chat-screen';
}
