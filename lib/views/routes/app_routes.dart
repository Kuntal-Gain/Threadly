import 'package:clozet/views/screens/order/orders_screen.dart';
import 'package:get/get.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/order/cart_screen.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/home_screen.dart';
import '../screens/feed/product_screen.dart';
import '../screens/order/checkout_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/splash_screen.dart';
import '../utils/widgets/redirection.dart';

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
    GetPage(name: '/auth', page: () => const AuthScreen()),
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
    GetPage(
      name: '/cart',
      page: () => CartScreen(
        userId: Get.arguments['userId'],
      ),
    ),
    GetPage(
      name: '/orders',
      page: () => OrderScreen(
        userId: Get.arguments['userId'],
      ),
    ),
    GetPage(name: '/checkout', page: () => const CheckoutScreen()),
  ];
}
