import 'package:clozet/views/utils/constants/color.dart';
import 'package:clozet/views/utils/constants/textstyle.dart';
import 'package:flutter/material.dart';

class SplashLogoScreen extends StatefulWidget {
  const SplashLogoScreen({super.key});

  @override
  State<SplashLogoScreen> createState() => _SplashLogoScreenState();
}

class _SplashLogoScreenState extends State<SplashLogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true); // makes it flicker endlessly
  }

  @override
  void dispose() {
    _controller.dispose(); // don't leak memory like an amateur 😤
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            "Threadly",
            style: TextStyleConst().headingStyle(
              color: AppColor.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
