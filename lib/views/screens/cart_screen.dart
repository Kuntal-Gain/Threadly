import 'package:clozet/models/products.dart';
import 'package:clozet/services/product_services.dart';
import 'package:clozet/views/utils/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/textstyle.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> qtys = [0, 0, 0];

  void clearItem(int idx) {
    setState(() {
      qtys.removeAt(idx);
    });
  }

  final CartController cartController = Get.find<CartController>();
  // final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    cartController.fetchCart();
  }

  Future<ProductModel?> fetchProductById(String productId) async {
    return await ProductServices().fetchProductById(productId);
  }

  double grandTotal(
          double totalPrice, double tax, double shippingFee, double discount) =>
      totalPrice == 0 ? 0 : totalPrice + tax + shippingFee - discount;

  List<double> prices = [];

  double getPrice(double price, int qty) => price * qty;

  Widget _cartItemTile({
    required ProductModel product,
    required int qty,
    required String size,
    required Function() onRemove,
    required Function() onAddQty,
    required Function() onRemoveQty,
  }) {
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
              product.snapshots.first,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: TextStyleConst().headingStyle(
                          color: AppColor.black,
                          size: 26,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onRemove(),
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
                      "Size : $size",
                      style: TextStyleConst().regularStyle(
                        color: AppColor.gray,
                        size: 19,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "₹${(product.price - (product.price * (product.discountValue / 100))) * qty}",
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColor.btnGray,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => onRemoveQty(),
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
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                                // You can also try: FadeTransition(opacity: animation, child: child);
                              },
                              child: Text(
                                '${qty < 10 ? "0$qty" : qty}',
                                key: ValueKey<int>(
                                    qty), // This is important for AnimatedSwitcher to know the value changed
                                style: TextStyleConst().headingStyle(
                                  color: AppColor.black,
                                  size: 20,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => onAddQty(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = cartController.cart.value;

      final totalPrice = cartController.totalPrice.value;

      if (cartController.isLoading.value) {
        return const Center(
          child: CupertinoActivityIndicator(
            color: AppColor.black,
          ),
        );
      }

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
                  itemCount: cart!.cartItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, idx) {
                    final qty = cart.qtys[idx];

                    return FutureBuilder<ProductModel?>(
                        future: fetchProductById(cart.cartItems[idx]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColor.primary,
                                ),
                              ),
                            );
                          }

                          return _cartItemTile(
                            product: snapshot.data!,
                            qty: qty,
                            size: cart.size,
                            // increase
                            onAddQty: () => cartController.incrementQty(idx),
                            // decrease
                            onRemoveQty: () => cartController.decrementQty(idx),
                            // remove whole tile
                            onRemove: () => cartController.removeByIndex(idx),
                          );
                        });
                  },
                ),
              ),

              // total price

              if (totalPrice != 0)
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
                            "₹${grandTotal(totalPrice, 10.2, 29.50, 10).toStringAsFixed(2)}",
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
    });
  }
}
