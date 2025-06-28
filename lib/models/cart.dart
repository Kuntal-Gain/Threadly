class CartModel {
  final String cartId;

  final List<String> cartItems;
  final List<int> qtys;
  final DateTime updatedAt;
  final String? couponCode;
  final double? shippingFee;
  final double? tax;

  CartModel({
    required this.cartId,
    required this.cartItems,
    required this.qtys,
    required this.updatedAt,
    this.couponCode,
    this.shippingFee,
    this.tax,
  });

  factory CartModel.fromMap(Map<String, dynamic> map, String id) => CartModel(
        cartId: id,
        cartItems: map['cartItems'],
        qtys: map['qtys'],
        updatedAt: DateTime.parse(map['updatedAt']),
        couponCode: map['couponCode'],
        shippingFee: map['shippingFee'] != null
            ? (map['shippingFee'] as num).toDouble()
            : null,
        tax: map['tax'] != null ? (map['tax'] as num).toDouble() : null,
      );

  Map<String, dynamic> toMap() => {
        'cartItems': cartItems,
        'qtys': qtys,
        'updatedAt': updatedAt.toIso8601String(),
        if (couponCode != null) 'couponCode': couponCode,
        if (shippingFee != null) 'shippingFee': shippingFee,
        if (tax != null) 'tax': tax,
      };
}
