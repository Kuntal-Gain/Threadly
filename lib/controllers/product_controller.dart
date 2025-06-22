import 'package:clozet/models/products.dart';

import 'package:get/get.dart';

import '../services/product_services.dart';

class ProductController extends GetxController {
  final ProductServices productServices;

  ProductController({required this.productServices});

  final RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    // code here
  }
}
