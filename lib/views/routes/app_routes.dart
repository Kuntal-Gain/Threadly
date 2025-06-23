import 'package:get/get.dart';

import '../screens/auth/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../utils/widgets/redirection.dart';
import '../utils/widgets/splash_logo.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const Redirection(
        loggedInRoute: "/home",
        loggedOutRoute: "/splash", // or splash/signup
      ),
    ),
    GetPage(name: '/home', page: () => const HomeScreen()),
    // GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/signup', page: () => SignupScreen()),
    GetPage(name: '/splash', page: () => const SplashScreen()),
    // GetPage(name: '/splash-loading', page: () => const SplashLogoScreen()),
  ];
}
