import 'package:car_fix_up/views/auth/login_view.dart';
import 'package:car_fix_up/views/dashboard/dashboard..dart';
import 'package:car_fix_up/views/components/splash.dart';
import 'package:car_fix_up/views/home/home_view.dart';
import 'package:get/get.dart';

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
        name: RouteName.home,
        page: (() => const HomeView()),
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
  static const String home = '/home';
  static const String dashboard = '/dashboard';
}
