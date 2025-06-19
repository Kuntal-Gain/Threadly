/*{uid , name , email , profileImage , address , wishlist[], cartID , orders[] , createAt}*/

class UserModel {
  final String uid;
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      address: map['address'],
      wishlist: map['wishlist'],
      cartID: map['cartID'],
      orders: map['orders'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'address': address,
      'wishlist': wishlist,
      'cartID': cartID,
      'orders': orders,
      'createdAt': createdAt,
    };
  }
}
