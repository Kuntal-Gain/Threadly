import 'package:flutter/material.dart';
import 'package:clozet/views/utils/constants/color.dart';
import 'package:clozet/views/utils/constants/textstyle.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.primary,
          ),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
        ),
        title: Text(
          "Checkout",
          style: TextStyleConst().headingStyle(
            color: AppColor.black,
            size: 26,
          ),
        ),
      ),
      body: const Center(
        child: Text("Checkout"),
      ),
    );
  }
}
