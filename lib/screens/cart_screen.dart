import 'package:clozet/utils/constants/color.dart';
import 'package:flutter/material.dart';

import '../utils/constants/sizes.dart';
import '../utils/constants/textstyle.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> qtys = [0, 0, 0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyleConst().headingStyle(
            color: AppColor.black,
            size: 26,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, idx) {
                  return Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://crazymonk.in/cdn/shop/files/CMVersity_1_CM.jpg?v=1749447196&width=713',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        sizeHor(12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Stylish T-Shirt",
                                      style: TextStyleConst().headingStyle(
                                        color: AppColor.black,
                                        size: 26,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // clear the [cart]
                                      },
                                      child: Image.asset(
                                        "assets/icons/close.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Size : XXL",
                                    style: TextStyleConst().regularStyle(
                                      color: AppColor.gray,
                                      size: 19,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "\$100.90",
                                    style: TextStyleConst().headingStyle(
                                      color: AppColor.black,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: AppColor.btnGray,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (qtys[idx] > 0) {
                                                  qtys[idx]--;
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          // Text(
                                          //   "${qtys[idx] < 10 ? "0${qtys[idx]}" : qtys[idx]}",
                                          //   style:
                                          //       TextStyleConst().headingStyle(
                                          //     color: AppColor.black,
                                          //     size: 20,
                                          //   ),
                                          // ),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return ScaleTransition(
                                                  scale: animation,
                                                  child: child);
                                              // You can also try: FadeTransition(opacity: animation, child: child);
                                            },
                                            child: Text(
                                              '${qtys[idx] < 10 ? "0${qtys[idx]}" : qtys[idx]}',
                                              key: ValueKey<int>(qtys[
                                                  idx]), // This is important for AnimatedSwitcher to know the value changed
                                              style:
                                                  TextStyleConst().headingStyle(
                                                color: AppColor.black,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                qtys[idx]++;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: AppColor.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // total price
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // price
                  Row(
                    children: [
                      Text(
                        "Total ",
                        style: TextStyleConst().regularStyle(
                          color: AppColor.white,
                          size: 24,
                        ),
                      ),
                      Text(
                        "\$${100.90.toStringAsFixed(2)}",
                        style: TextStyleConst().headingStyle(
                          color: AppColor.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),

                  // button

                  Container(
                    // height: 60,
                    width: 160,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Checkout",
                        style: TextStyleConst().headingStyle(
                          color: AppColor.black,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
