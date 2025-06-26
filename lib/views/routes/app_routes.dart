import 'package:get/get.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_screen.dart';
import '../screens/search_screen.dart';
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
    GetPage(name: '/auth', page: () => AuthScreen()),
    GetPage(name: '/splash', page: () => const SplashScreen()),
    // GetPage(name: '/splash-loading', page: () => const SplashLogoScreen()),
    GetPage(name: '/feed', page: () => const FeedScreen()),
    GetPage(
        name: '/product',
        page: () {
          final id = Get.arguments['id'];

          return ProductDetailsScreen(productID: id);
        }),

    GetPage(name: '/search', page: () => const SearchScreen()),
  ];
}
