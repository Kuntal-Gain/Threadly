import 'package:clozet/views/utils/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/users.dart';
import '../utils/constants/color.dart';
import '../widgets/ad_widget.dart';

class FeedScreen extends StatefulWidget {
  final UserModel? user;
  const FeedScreen({super.key, this.user});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> categories = [
    'All',
    'Men',
    'Women',
    'T-Shirts',
    'Hoodies',
    'Accessories',
    'Trending',
  ];

  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  int _currentIdx = 0;

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int cartCount = cartController.cart.value!.cartItems.length;

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xffc2c2c2),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: GoogleFonts.firaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              widget.user?.name ?? "Guest",
                              style: TextStyleConst().headingStyle(
                                color: Colors.black,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/cart');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xffc2c2c2),
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              const SizedBox(height: 50, width: 40),
                              Positioned(
                                top: 5,
                                left: 2,
                                child: Image.asset(
                                  'assets/icons/market.png',
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                  child: Center(
                                    child: Text(
                                      cartCount.toString(),
                                      style: TextStyleConst().headingStyle(
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                adWidget(
                  label: 'Get Your Special\nSale upto ',
                  imageUrl: 'assets/ads-1.png',
                  discount: 50,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIdx = categories.indexOf(category);
                                });
                              },
                              child: Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: _currentIdx !=
                                          categories.indexOf(category)
                                      ? Colors.white
                                      : const Color(0xff1a1f22),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyleConst().regularStyle(
                                      color: _currentIdx !=
                                              categories.indexOf(category)
                                          ? Colors.black
                                          : Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                // Product grid
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: productController.products.length,
                      itemBuilder: (context, index) {
                        final product = productController.products[index];

                        debugPrint(product.snapshots.first);
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              '/product',
                              arguments: {'id': product.productId},
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      product.snapshots.first,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(product.title,
                                      style: TextStyleConst().headingStyle(
                                        color: Colors.black,
                                        size: 25,
                                      )),
                                  Text('\$${product.price}',
                                      style: TextStyleConst().headingStyle(
                                        color: Colors.black,
                                        size: 25,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
