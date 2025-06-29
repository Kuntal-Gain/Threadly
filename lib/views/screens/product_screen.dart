import 'package:clozet/views/utils/constants/color.dart';
import 'package:clozet/views/utils/widgets/color_conversion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/products.dart';
import '../utils/constants/textstyle.dart';
import '../widgets/price_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productID});

  final String productID;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  int _currentIdx = 0;
  int _selectedSz = 0;
  int _quantity = 1;
  int _selectedColor = 0;

  static const _placeholder =
      'https://via.placeholder.com/500x500.png?text=No+Image';

  @override
  void initState() {
    super.initState();
    productController.fetchProductById(widget.productID);
  }

  // ───────────────── image helpers ─────────────────
  Widget _bigImage(List<String> snaps, Size mq) {
    // ensure we always have at least one item to show
    final data = snaps.isEmpty ? [_placeholder] : snaps;

    // reset idx if we scrolled past the new list length
    if (_currentIdx >= data.length) _currentIdx = 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            data[_currentIdx],
            width: mq.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _thumbs(List<String> snaps) {
    if (snaps.isEmpty) return const SizedBox(); // nothing to show

    return Positioned(
      right: 30,
      top: 40,
      child: SizedBox(
        height: (100 * snaps.length.clamp(0, 3)).toDouble(),
        width: 75,
        child: ListView.builder(
          itemCount: snaps.length.clamp(0, 3),
          itemBuilder: (_, index) {
            final bool showExtra = index == 2 && snaps.length > 3;
            return GestureDetector(
              onTap: () => setState(() => _currentIdx = index),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black, blurRadius: 3, spreadRadius: 1),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          snaps[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      if (showExtra)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      if (showExtra)
                        Center(
                          child: Text(
                            '+${snaps.length - 3}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ───────────────── size & qty widgets ─────────────────
  Widget _sizeSelector(List<String> sizes) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: sizes.map((size) {
          final idx = sizes.indexOf(size);
          return GestureDetector(
            onTap: () => setState(() => _selectedSz = idx),
            child: Container(
              height: 60,
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color:
                    idx == _selectedSz ? const Color(0xff131b1e) : Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xffc2c2c2), blurRadius: 3, spreadRadius: 1),
                ],
              ),
              child: Center(
                child: Text(
                  size,
                  style: TextStyle(
                    color: idx == _selectedSz ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );

  // ───────────────── color selector ─────────────────

  Widget _colorSelector(List<String> colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: colors.map((hex) {
          final idx = colors.indexOf(hex);
          final colorInt = stringToColorInt(hex);

          return GestureDetector(
            onTap: () => setState(() => _selectedColor = idx),
            child: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: idx == _selectedColor
                    ? Border.all(color: Colors.deepPurple, width: 5)
                    : Border.all(color: Colors.white, width: 5),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(colorInt),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xffc2c2c2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _qtySelector(Size mq) => Expanded(
        child: Container(
          height: mq.height * .07,
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xff1c282e),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => setState(() => _quantity++),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (c, a) =>
                    ScaleTransition(scale: a, child: c),
                child: Text(
                  '$_quantity',
                  key: ValueKey<int>(_quantity),
                  style: TextStyleConst()
                      .headingStyle(color: Colors.white, size: 25),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed:
                    _quantity > 1 ? () => setState(() => _quantity--) : null,
              ),
            ],
          ),
        ),
      );

  Widget _bottomBar(Size mq, ProductModel p) => Container(
        width: mq.width,
        height: mq.height * .08,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: const Color(0xff131b1e),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(color: Color(0xffc2c2c2), blurRadius: 3, spreadRadius: 1)
          ],
        ),
        child: Row(
          children: [
            _qtySelector(mq),
            const SizedBox(width: 25),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  cartController.addItem(
                    widget.productID,
                    p.sizes[_selectedSz],
                    p.colors[_selectedColor],
                    quantity: _quantity,
                  );
                },
                child: Container(
                  height: mq.height * .07,
                  margin: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Add to Cart',
                      style: TextStyleConst()
                          .headingStyle(color: Colors.black, size: 26),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget productValueWidget(String label, int value) => Row(
        children: [
          const CircleAvatar(radius: 5, backgroundColor: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text('$value+ $label'),
          ),
        ],
      );

  // ───────────────── product widget ─────────────────
  Widget _buildProduct(ProductModel p, Size mq) {
    final avg = p.ratings.isEmpty
        ? 0.0
        : p.ratings.reduce((a, b) => a + b) / p.ratings.length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              _bigImage(p.snapshots, mq),
              _thumbs(p.snapshots),
              Positioned(
                top: 30,
                left: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white)),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(p.title,
                  style: TextStyleConst()
                      .headingStyle(color: Colors.black, size: 45)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 10),
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xff131b1e),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 20),
                            Text(avg.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    const Text('Ratings'),
                  ],
                ),
                productValueWidget('Reviews', p.reviews.length),
                productValueWidget('Sold', p.soldUnits),
              ],
            ),
            priceWidget(
                price: p.price.toDouble(),
                discount: p.discountValue.toDouble()),
            _colorSelector(p.colors),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(p.description,
                  style: TextStyleConst()
                      .headingStyle(color: Colors.grey, size: 16)),
            ),
            _sizeSelector(p.sizes),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── build ──────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final p = productController.product.value;
        if (p == null) {
          return const Center(child: Text('Product not found 🤷‍♂️'));
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 100), // Reserve space for bottom bar
              child: SingleChildScrollView(
                child: _buildProduct(p, MediaQuery.of(context).size),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _bottomBar(MediaQuery.of(context).size, p),
            ),
          ],
        );
      }),
    );
  }
}
