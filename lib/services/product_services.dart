import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';

import '../models/products.dart';
import '../views/utils/constants/appwrite.dart';

class ProductServices {
  final Client _client = Client()
    ..setEndpoint(APPWRITE_ENDPOINT)
    ..setProject(APPWRITE_PROJECT_ID);

  late final Databases _db = Databases(_client);

  // 🛍️ Fetch products from Appwrite
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final models.DocumentList docs = await _db.listDocuments(
        databaseId: databaseId,
        collectionId: productsCollectionId, // make sure this matches
      );

      return docs.documents
          .map((doc) => ProductModel.fromDocument(doc))
          .toList();
    } on AppwriteException catch (e) {
      debugPrint('❌ Appwrite error while fetching products: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('❌ Unexpected error while fetching products: $e');
      return [];
    }
  }

  Future<ProductModel?> fetchProductById(String productId) async {
    try {
      debugPrint('➡️  Appwrite getDocument: $productId');
      final models.Document doc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: productsCollectionId,
        documentId: productId,
      );

      return ProductModel.fromDocument(doc);
    } on AppwriteException catch (e, s) {
      // Common 404 means "document not found"
      debugPrint('❌ Appwrite (${e.code}) ${e.message}\n$s');
      return null;
    } catch (e, s) {
      debugPrint('❌ Unexpected fetchProductById error: $e\n$s');
      return null;
    }
  }
}
