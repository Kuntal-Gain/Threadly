import 'package:get/get.dart';

import '../models/cart.dart';
import '../services/cart_service.dart';

class CartController extends GetxController {
  final CartService cartServices; // <- inject via DI

  CartController({required this.cartServices});

  /// Reactive cart model (null until loaded)
  final Rxn<CartModel> cart = Rxn<CartModel>();

  /// Convenience reactive flags
  RxBool isLoading = false.obs;

  // ──────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // ──────────────────────────────────────────
  // PUBLIC METHODS
  // ──────────────────────────────────────────
  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      cart.value = await cartServices.getCart();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem(String productId, String size, String color,
      {int quantity = 1}) async {
    await cartServices.addToCart(productId, size, color, quantity: quantity);
    await fetchCart(); // refresh local state
  }

  Future<void> removeItem(String productId) async {
    await cartServices.deleteCartItem(productId);
    await fetchCart();
  }

  Future<void> clear() async {
    await cartServices.clearCart();
    await fetchCart();
  }

  int get totalItems => cart.value?.qtys.fold<int>(0, (sum, q) => sum + q) ?? 0;
}
