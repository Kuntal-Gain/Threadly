import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../models/products.dart';
import '../utils/constants/color.dart';
import '../utils/constants/textstyle.dart';
import '../widgets/ad_widget.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController textCtrl = TextEditingController();

  List<ProductModel> searchList = [];

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();
    textCtrl.addListener(_handleSearch);
  }

  void _handleSearch() {
    final query = textCtrl.text.toLowerCase();
    setState(() {
      searchList = productController.products
          .where((product) => product.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    textCtrl.removeListener(_handleSearch);
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (productController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Column(
            children: [
              // 🔍 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 50,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(color: AppColor.gray, blurRadius: 2),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset('assets/icons/search.png',
                        width: 25, height: 25),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for Stylish T-Shirt",
                          hintStyle: TextStyleConst()
                              .regularStyle(color: AppColor.black, size: 18),
                        ),
                      ),
                    ),
                    if (textCtrl.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          textCtrl.clear();
                          FocusScope.of(context).unfocus();
                          setState(() => searchList.clear());
                        },
                        child: Image.asset('assets/icons/close.png',
                            width: 25, height: 25),
                      ),
                  ],
                ),
              ),

              // 🔢 Result Count + Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${searchList.length} Results",
                      style: TextStyleConst()
                          .headingStyle(color: AppColor.black, size: 26),
                    ),
                    Image.asset('assets/icons/settings-sliders.png',
                        width: 32, height: 32),
                  ],
                ),
              ),

              // 🔄 Results Grid
              Expanded(
                child: searchList.isEmpty
                    ? const Center(child: Text("No products found 😢"))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            final ProductModel product = searchList[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                      productID: product.productId),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: Colors.black, size: 24)),
                                    Text('₹${product.price}',
                                        style: TextStyleConst().headingStyle(
                                            color: Colors.black, size: 22)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
