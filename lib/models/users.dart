class UserModel {
  final String uid; // This will map to Appwrite's $id
  final String name;
  final String email;
  final String profileImage;
  final String address;
  final List<String> wishlist;
  final String cartID;
  final List<String> orders;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.address,
    required this.wishlist,
    required this.cartID,
    required this.orders,
    required this.createdAt,
  });

  /// Convert from Appwrite's Map (aka Document `data`)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'], // Appwrite uses $id for document ID
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      address: map['address'],
      wishlist: List<String>.from(map['wishlist'] ?? []),
      cartID: map['cartID'],
      orders: List<String>.from(map['orders'] ?? []),
      createdAt: DateTime.parse(map['\$createdAt']),
    );
  }

  /// Convert to Appwrite-friendly map
  Map<String, dynamic> toMap() {
    return {
      // 'uid' is NOT required because Appwrite sets $id automatically
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'address': address,
      'wishlist': wishlist,
      'cartID': cartID,
      'orders': orders,
      // 'createdAt' is NOT stored by us, Appwrite sets $createdAt automatically
    };
  }
}
