import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/products.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.productId)
        .update(product.toMap());
  }

  Future<void> deleteProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.productId).delete();
  }
}
