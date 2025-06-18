import 'package:clozet/models/products.dart';
import 'package:get/get.dart';

import '../services/firebase_services.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await firebaseServices.fetchProducts();
      products.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    }
  }
}
