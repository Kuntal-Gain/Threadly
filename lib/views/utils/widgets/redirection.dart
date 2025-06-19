import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/user_services.dart';

class Redirection extends StatelessWidget {
  final String loggedInRoute;
  final String loggedOutRoute;

  const Redirection({
    super.key,
    required this.loggedInRoute,
    required this.loggedOutRoute,
  });

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final userService = Get.find<UserServices>();
      final isLoggedIn = await userService.isOnline();

      if (isLoggedIn) {
        Get.toNamed(loggedInRoute);
      } else {
        Get.toNamed(loggedOutRoute);
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Optional loading UI
    );
  }
}
