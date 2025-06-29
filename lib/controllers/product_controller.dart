import 'package:flutter/foundation.dart'; // debugPrint
import 'package:get/get.dart';
import 'package:clozet/models/products.dart';
import 'package:clozet/services/product_services.dart';

class ProductController extends GetxController {
  ProductController({required this.productServices});

  final ProductServices productServices;

  /// Complete catalogue
  final RxList<ProductModel> products = <ProductModel>[].obs;

  /// Currently viewed / selected product
  final Rxn<ProductModel> product = Rxn<ProductModel>();

  /// Global loading flag
  final RxBool isLoading = false.obs;

  // ────────────────────────── lifecycle ──────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // pre-load catalogue
  }

  // ────────────────────────── public API ─────────────────────────
  Future<void> fetchProducts() async => _wrapWithLoader(() async {
        products.value = await productServices.fetchProducts();
      });

  Future<void> fetchProductById(String id) async => _wrapWithLoader(() async {
        product.value = await productServices.fetchProductById(id);
      });

  // ────────────────────────── helpers ────────────────────────────
  Future<void> _wrapWithLoader(Future<void> Function() task) async {
    try {
      isLoading.value = true;
      await task();
    } catch (e, s) {
      debugPrint('❌ ProductController error: $e\n$s');
    } finally {
      isLoading.value = false;
    }
  }
}
