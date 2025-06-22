import 'dart:async';

import 'package:clozet/views/screens/auth/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/constants/textstyle.dart';
import '../utils/widgets/redirection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<double> opacities = [0.3, 0.3, 0.3];
  int currentIndex = 0;
  // Add these two variables at the top of your _SplashScreenState
  double dragOffsetX = 0.0;
  final double dragThreshold = 150.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        opacities = [0.3, 0.3, 0.3];
        opacities[currentIndex] = 1.0;
        currentIndex = (currentIndex + 1) % 3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
        ),
        Image.asset(
          'assets/splash.webp',
          fit: BoxFit.cover,
          cacheWidth: 720,
        ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              "Clozet",
              style: TextStyleConst().headingStyle(
                color: Colors.white,
                size: mq.height * 0.06,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.38,
            decoration: const BoxDecoration(
              color: Color(0xff121a1c),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discover Our New Dress For You',
                  style: TextStyleConst().headingStyle(
                    color: Colors.white,
                    size: mq.height * 0.05,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                    height: mq.height * 0.09,
                    width: mq.width,
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff1c2c32),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              dragOffsetX += details.delta.dx;
                              if (dragOffsetX < 0) {
                                dragOffsetX = 0; // Prevent dragging left
                              }
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            if (dragOffsetX > dragThreshold) {
                              // Trigger your action here (like navigation)
                              if (kDebugMode) {
                                print("🎉 Swipe successful!");
                              }

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            }
                            // Reset position
                            setState(() {
                              dragOffsetX = 0;
                            });
                          },
                          child: Transform.translate(
                            offset: Offset(dragOffsetX, 0),
                            child: Container(
                              height: mq.height * 0.08,
                              width: mq.width * 0.4,
                              margin: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyleConst().headingStyle(
                                    color: Colors.black,
                                    size: mq.height * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            AnimatedOpacity(
                              opacity: opacities[0],
                              duration: const Duration(milliseconds: 300),
                              child: Image.asset(
                                'assets/right-arrow.png',
                                height: 30,
                                width: 30,
                                color: Colors.white54,
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: opacities[1],
                              duration: const Duration(milliseconds: 300),
                              child: Image.asset(
                                'assets/right-arrow.png',
                                height: 30,
                                width: 30,
                                color: Colors.white60,
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: opacities[2],
                              duration: const Duration(milliseconds: 300),
                              child: Image.asset(
                                'assets/right-arrow.png',
                                height: 30,
                                width: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        )
      ],
    ));
  }
}
