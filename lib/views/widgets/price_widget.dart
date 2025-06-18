import 'package:clozet/views/utils/constants/textstyle.dart';
import 'package:flutter/material.dart';

Widget priceWidget({required double price, required double discount}) {
  final newPrice = price - price * (discount / 100);

  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Text(
          "\$${newPrice.toStringAsFixed(0)}",
          style: TextStyleConst().headingStyle(
            color: Colors.black,
            size: 40,
          ),
        ),
      ),
      Text(
        "\$${price.toStringAsFixed(0)}",
        style: TextStyleConst().headingStyle(
          textStyle: const TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
          color: Colors.grey,
          size: 25,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xffc2c2c2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            "${discount.toStringAsFixed(0)}%",
            style: TextStyleConst().headingStyle(
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
      )
    ],
  );
}
