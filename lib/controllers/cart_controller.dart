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

  /// quick cache of fetched products (productId → ProductModel)
  final Map<String, ProductModel> _productCache = {};

  // ──────────────────────────────────────────
  // Lifecycle
  // ──────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchCart(); // loads cart & computes total
  }

  // ──────────────────────────────────────────
  // Public helpers
  // ──────────────────────────────────────────
  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      cart.value = await cartServices.getCart();
      await _warmProductCache();
      _recalcTotal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem(
    String productId,
    String size,
    String color, {
    int quantity = 1,
  }) async {
    await cartServices.addToCart(productId, size, color, quantity: quantity);
    await fetchCart(); // reload + recalc
  }

  Future<void> removeItem(String productId) async {
    await cartServices.deleteCartItem(productId);
    await fetchCart();
  }

  Future<void> clear() async {
    await cartServices.clearCart();
    await fetchCart();
  }

  // Increment / decrement qty for a given index in the local cart
  void incrementQty(int idx) {
    if (cart.value == null) return;
    cart.value!.qtys[idx] += 1;
    totalPrice.value += _itemPrice(idx);
    update(); // GetX manual update for widgets using GetBuilder, optional
  }

  void decrementQty(int idx) {
    if (cart.value == null) return;
    if (cart.value!.qtys[idx] == 0) return;
    cart.value!.qtys[idx] -= 1;
    totalPrice.value -= _itemPrice(idx);
    update();
  }

  // Remove by list index (used by “X” button)
  void removeByIndex(int idx) {
    if (cart.value == null) return;
    totalPrice.value -= _itemPrice(idx) * cart.value!.qtys[idx];
    cart.value!.cartItems.removeAt(idx);
    cart.value!.qtys.removeAt(idx);
    update();
  }

  int get totalItems => cart.value?.qtys.fold<int>(0, (sum, q) => sum + q) ?? 0;

  // ──────────────────────────────────────────
  // Internal helpers
  // ──────────────────────────────────────────
  Future<void> _warmProductCache() async {
    if (cart.value == null) return;

    final idsToFetch = cart.value!.cartItems
        .where((id) => !_productCache.containsKey(id))
        .toList();
    if (idsToFetch.isEmpty) return;

    final products = await productServices.fetchProducts();
    for (final p in products) {
      _productCache[p.productId] = p;
    }
  }

  double _itemPrice(int idx) {
    final pid = cart.value!.cartItems[idx];
    final product = _productCache[pid];
    if (product == null) return 0;
    final discounted =
        product.price - product.price * (product.discountValue / 100);
    return discounted;
  }

  void _recalcTotal() {
    totalPrice.value = 0;
    if (cart.value == null) return;
    for (var i = 0; i < cart.value!.cartItems.length; i++) {
      totalPrice.value += _itemPrice(i) * cart.value!.qtys[i];
    }
  }
}
