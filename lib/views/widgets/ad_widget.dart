import 'package:flutter/material.dart';

import '../utils/constants/textstyle.dart';

Widget adWidget({
  required String label,
  required String imageUrl,
  required int discount,
}) {
  return Container(
    height: 240, // 👈 sets the actual height
    margin: const EdgeInsets.symmetric(horizontal: 12),
    width: double.infinity,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Layer 1 - Bottom Image/Overlay

        // Layer 2 - Middle Container
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xff1a1f22),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    label,
                    style: TextStyleConst().headingStyle(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 130,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Shop Now',
                      style: TextStyleConst().headingStyle(
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        // Layer 3 - Discount Text on top left
        Positioned(
          top: 95,
          left: 155,
          child: Text(
            '$discount%',
            style: TextStyleConst().headingStyle(
              color: Colors.white,
              size: 60,
            ),
          ),
        ),

        // Layer 4 - Top Right Image
        Positioned(
          top: -15,
          right: -30,
          child: Image.asset(
            imageUrl,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}
