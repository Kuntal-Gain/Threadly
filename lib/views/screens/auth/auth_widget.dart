import 'package:flutter/material.dart';

Widget authProvider(String url, [Function()? onTap]) {
  onTap ??= () {
    debugPrint("no implemented");
  };
  return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image.network(
              url,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ));
}
