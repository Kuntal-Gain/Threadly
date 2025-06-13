import 'package:clozet/utils/constants/color.dart';
import 'package:flutter/material.dart';

Widget navIcon({
  required String icon,
  required bool isSelected,
  Function()? onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut, // gives a nice bounce
        height: isSelected ? 65 : 60, // bump up size when selected
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          icon,
          color: !isSelected ? AppColor.white : AppColor.primary,
          height: isSelected ? 25 : 20, // animate icon size too
          width: isSelected ? 25 : 20,
        ),
      ),
    ),
  );
}
