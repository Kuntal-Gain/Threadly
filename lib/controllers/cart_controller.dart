// -----------------------------------------------------------------------------
// cart_controller_and_screen.dart  –  Controller + Screen (v2)
// -----------------------------------------------------------------------------
// Matches the **reactive CartController** (totalPrice + discountTotal).
// CartScreen no longer keeps local `discount`/`prices` lists—totals flow
// directly from the controller. Qty buttons simply mutate the controller and
// let Obx rebuild footer + list tiles.
// -----------------------------------------------------------------------------

// ============================  CartController  ===============================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart.dart';
import '../models/products.dart';
import '../services/cart_service.dart';
import '../services/product_services.dart';

class CartController extends GetxController {
  final CartService cartServices;
  final ProductServices productServices;

  CartController({
    required this.cartServices,
    required this.productServices,
  });

  // ──────────────────────────────────────────
  // Reactive state
  // ──────────────────────────────────────────
  final Rxn<CartModel> cart = Rxn<CartModel>();
  final RxBool isLoading = false.obs;
  final RxDouble totalPrice = 0.0.obs;
  final RxDouble discountTotal = 0.0.obs;

  /// quick cache (productId → ProductModel)
  final Map<String, ProductModel> _productCache = {};

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchCart());
  }

  // ──────────────────────────────────────────
  // Public helpers
  // ──────────────────────────────────────────
  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      cart.value = await cartServices.getCart();
      await _warmProductCache();
      _recalcTotals();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem(String productId, String size, String color,
      {int quantity = 1}) async {
    await cartServices.addToCart(productId, size, color, quantity: quantity);
    await fetchCart();
  }

  Future<void> removeItem(String productId) async {
    await cartServices.deleteCartItem(productId);
    await fetchCart();
  }

  Future<void> clear() async {
    await cartServices.clearCart();
    await fetchCart();
  }

  // qty tweaks ---------------------------------------------------------------
  void incrementQty(int idx) {
    if (cart.value == null) return;
    cart.value!.qtys[idx] += 1;
    _recalcTotals();
  }

  void decrementQty(int idx) {
    if (cart.value == null) return;
    if (cart.value!.qtys[idx] == 0) return;
    cart.value!.qtys[idx] -= 1;
    _recalcTotals();
  }

  void removeByIndex(int idx) {
    if (cart.value == null) return;
    cart.value!.cartItems.removeAt(idx);
    cart.value!.qtys.removeAt(idx);
    _recalcTotals();
  }

  // ──────────────────────────────────────────
  // Internal helpers
  // ──────────────────────────────────────────
  Future<void> _warmProductCache() async {
    if (cart.value == null) return;
    final missing = cart.value!.cartItems
        .where((id) => !_productCache.containsKey(id))
        .toList();
    if (missing.isEmpty) return;

    final products = await productServices.fetchProducts();
    for (final p in products) {
      _productCache[p.productId] = p;
    }
  }

  double _discountedPrice(ProductModel p) =>
      p.price - p.price * (p.discountValue / 100);

  void _recalcTotals() {
    totalPrice.value = 0;
    discountTotal.value = 0;
    if (cart.value == null) return;

    for (var i = 0; i < cart.value!.cartItems.length; i++) {
      final pid = cart.value!.cartItems[i];
      final product = _productCache[pid];
      if (product == null) continue;

      final qty = cart.value!.qtys[i];
      final discounted = _discountedPrice(product);

      totalPrice.value += discounted * qty;
      discountTotal.value += (product.price - discounted) * qty;
    }
  }
}
