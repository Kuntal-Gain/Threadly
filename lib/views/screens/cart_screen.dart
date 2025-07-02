import 'package:clozet/models/cart.dart';
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
  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    cartController.fetchCart();
  }

  Future<ProductModel?> fetchProductById(String productId) async {
    return await ProductServices().fetchProductById(productId);
  }

  double grandTotal(double subtotal, double shippingFee, double discount) =>
      subtotal == 0 ? 0 : subtotal + shippingFee - discount;

  Widget _cartItemTile({
    required ProductModel product,
    required int qty,
    required String size,
    required Function() onRemove,
    required Function() onAddQty,
    required Function() onRemoveQty,
  }) {
    final discountedPrice =
        product.price - (product.price * (product.discountValue / 100));
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
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "₹${(discountedPrice * qty).toStringAsFixed(2)}",
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
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => onRemoveQty(),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColor.btnGray,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: AppColor.black,
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: Text(
                                '${qty < 10 ? "0$qty" : qty}',
                                key: ValueKey<int>(qty),
                                style: TextStyleConst().headingStyle(
                                  color: AppColor.black,
                                  size: 25,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => onAddQty(),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColor.white,
                                ),
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

  Widget _priceWidgetItem(String label, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyleConst().regularStyle(
                  color: AppColor.black,
                  size: 24,
                ),
              ),
              Text(
                "₹${price.toStringAsFixed(2)}",
                style: TextStyleConst().headingStyle(
                  color: AppColor.black,
                  size: 24,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              color: AppColor.gray,
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomBar(Size size, double totalPrice) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(50),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          "Proceed to Checkout",
          style: TextStyleConst().headingStyle(
            color: AppColor.white,
            size: 26,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = cartController.cart.value;
      final totalPrice = cartController.totalPrice.value;
      final discount = cartController.discountTotal.value;

      if (cartController.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: const Center(
            child: CupertinoActivityIndicator(
              color: AppColor.black,
            ),
          ),
        );
      }

      final mq = MediaQuery.of(context).size;

      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.black,
            ),
            onPressed: () => Get.back(),
          ),
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
        body: Padding(
          padding: EdgeInsets.only(bottom: mq.height * .03),
          child: Stack(
            children: [
              _bodyWidget(cart!, totalPrice, discount),
              if (cart.cartItems.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _bottomBar(mq, totalPrice),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _bodyWidget(CartModel cart, double totalPrice, double discount) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            itemCount: cart.cartItems.length,
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

                  final product = snapshot.data!;

                  return _cartItemTile(
                    product: product,
                    qty: qty,
                    size: cart.size,
                    onAddQty: () =>
                        setState(() => cartController.incrementQty(idx)),
                    onRemoveQty: () =>
                        setState(() => cartController.decrementQty(idx)),
                    onRemove: () =>
                        setState(() => cartController.removeByIndex(idx)),
                  );
                },
              );
            },
          ),
        ),
        sizeVar(10),
        _priceWidgetItem('Subtotal', totalPrice),
        sizeVar(10),
        _priceWidgetItem('Tax', 12.90),
        sizeVar(10),
        _priceWidgetItem('Discount', discount),
        sizeVar(10),
        _priceWidgetItem(
            'Grand Total', grandTotal(totalPrice, 12.90, discount)),
      ],
    );
  }
}
