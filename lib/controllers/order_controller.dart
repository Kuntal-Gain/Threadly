import 'package:get/get.dart';

import '../models/order.dart';
import '../services/order_service.dart';

class OrderController extends GetxController {
  // Inject your service via DI if you prefer.
  final OrderService orderService;
  OrderController({required this.orderService});

  // ────────────────────────────────────────
  // Reactive state
  // ────────────────────────────────────────
  final RxList<OrderModel> orders = <OrderModel>[].obs; // user’s orders
  final Rxn<OrderModel> currentOrder = Rxn<OrderModel>(); // single order view

  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  // ────────────────────────────────────────
  // CRUD wrappers
  // ────────────────────────────────────────

  /// Create & immediately push to list.
  Future<void> createOrder(OrderModel order) async {
    try {
      isCreating.value = true;
      final created = await orderService.createOrder(order);
      orders.insert(0, created); // newest first
    } finally {
      isCreating.value = false;
    }
  }

  /// Fetch all orders for [userId] and cache in `orders`.
  Future<void> fetchOrders(String userId) async {
    isLoading.value = true;
    try {
      final fetched = await orderService.fetchOrders(userId);
      orders.assignAll(fetched);
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch a single order by id and expose in `currentOrder`.
  Future<void> fetchSingle(String orderId) async {
    isLoading.value = true;
    try {
      currentOrder.value = await orderService.fetchOrderById(orderId);
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel an order, update in local list & currentOrder if open.
  Future<void> cancelOrder(String orderId) async {
    await orderService.cancelOrder(orderId);
    // Update cached order object(s)
    final idx = orders.indexWhere((o) => o.orderId == orderId);
    if (idx != -1) {
      orders[idx].statuses.add('Cancelled');
      orders.refresh();
    }
    if (currentOrder.value?.orderId == orderId) {
      currentOrder.value!.statuses.add('Cancelled');
      currentOrder.refresh();
    }
  }
}
