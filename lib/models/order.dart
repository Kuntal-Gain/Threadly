class OrderModel {
  // core
  final String orderId;
  final String userId;
  final List<String> productIds;
  final List<int> qtys;
  final double grandTotal;
  final String deliveryAddress;

  // status tracking
  final List<String> statuses;

  // extras
  final String? paymentMethod;

  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.productIds,
    required this.qtys,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.statuses,
    required this.createdAt,
    this.paymentMethod,
  });

  // ───────────────────────────── factory ─────────────────────────────
  factory OrderModel.fromMap(Map<String, dynamic> map, String id) => OrderModel(
        orderId: id,
        userId: map['userId'],
        productIds: List<String>.from(map['productIds']),
        qtys: List<int>.from(map['qtys']),
        grandTotal: (map['grandTotal'] as num).toDouble(),
        deliveryAddress: map['deliveryAddress'],
        statuses: List<String>.from(map['statuses']),
        paymentMethod: map['paymentMethod'],
        createdAt: DateTime.parse(map['createdAt']),
      );

  // ─────────────────────────────  toMap  ─────────────────────────────
  Map<String, dynamic> toMap() => {
        'orderId': orderId,
        'userId': userId,
        'productIds': productIds,
        'qtys': qtys,
        'grandTotal': grandTotal,
        'deliveryAddress': deliveryAddress,
        'statuses': ["Order Placed / ${createdAt.toIso8601String()}"],
        'paymentMethod': paymentMethod,
        'createdAt': createdAt.toIso8601String(),
      };
}
