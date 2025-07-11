import 'package:clozet/views/screens/feed/feed_screen.dart';
import 'package:clozet/views/screens/profile/profile_screen.dart';
import 'package:clozet/views/utils/widgets/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../utils/widgets/nav_icons.dart';
import 'search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _screens = [];
  final UserController userController = Get.find<UserController>();

  int _currentIdx = 0;

  void _onTap(int idx) {
    setState(() {
      _currentIdx = idx;
    });
  }

  @override
  void initState() {
    super.initState();
    userController.fetchCurrentUser();
    debugPrint("✅ HomeScreen initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = userController.currentUser.value;

      if (user == null) {
        return const SplashLogoScreen();
      }

      _screens = [
        FeedScreen(user: user),
        const SearchScreen(),
        const Center(child: Text("Wishlist")),
        ProfileScreen(user: user),
      ];

      return Scaffold(
        backgroundColor: Colors.white,
        body: _screens[_currentIdx],
        bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff121a1c),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navIcon(
                icon: "assets/icons/home.png",
                isSelected: _currentIdx == 0,
                onTap: () => _onTap(0),
              ),
              navIcon(
                icon: "assets/icons/search.png",
                isSelected: _currentIdx == 1,
                onTap: () => _onTap(1),
              ),
              navIcon(
                icon: "assets/icons/wishlist.png",
                isSelected: _currentIdx == 2,
                onTap: () => _onTap(2),
              ),
              navIcon(
                  icon: "assets/icons/user.png",
                  isSelected: _currentIdx == 3,
                  onTap: () => _onTap(3)),
            ],
          ),
        ),
      );
    });
  }
}
