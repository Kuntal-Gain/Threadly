import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:clozet/services/user_services.dart';
import 'package:flutter/foundation.dart';

import '../models/cart.dart';
import '../views/utils/constants/appwrite.dart';

class CartService {
  final Client _client = Client()
    ..setEndpoint(APPWRITE_ENDPOINT)
    ..setProject(APPWRITE_PROJECT_ID);

  late final Account _account = Account(_client);
  late final Databases _db = Databases(_client);
  late final Storage _storage = Storage(_client);

  /// Creates a new cart for the current [user].
  /// Throws if [user] not logged in or Appwrite errors occur.
  Future<void> createCart() async {
    try {
      final uid = await UserServices().getCurrentUid();
      if (uid == null) throw Exception('User not logged in');

      // Attempt to create. If the doc already exists, Appwrite will throw 409.
      await _db.createDocument(
        databaseId: databaseId,
        collectionId: cartCollectionId,
        documentId: uid, // uid == cartId
        data: {
          'userId': uid,
          'cartItems': <String>[], // empty array
          'qtys': <int>[], // parallel empty array
          'updatedAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(uid)),
          Permission.write(Role.user(uid)),
        ],
      );
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        // Doc already exists – silently ignore or log if you want
        debugPrint('ℹ️ Cart already exists for this user.');
      } else {
        debugPrint('❌ Appwrite createCart error: ${e.message}');
        rethrow;
      }
    } catch (e) {
      debugPrint('❌ createCart failed: $e');
      rethrow;
    }
  }

  /// Adds [productId] to the current user’s cart.
  /// If the product is already present, its quantity is bumped.
  /// Throws if user not logged in or Appwrite errors occur.
  Future<void> addToCart(String productId) async {
    try {
      // 1️⃣ current user
      final uid = await UserServices().getCurrentUid();
      if (uid == null) throw Exception('User not logged in');

      // 2️⃣ try to fetch the cart (docId == uid)
      Document? cartDoc;
      try {
        cartDoc = await _db.getDocument(
          databaseId: databaseId,
          collectionId: cartCollectionId,
          documentId: uid,
        );
      } on AppwriteException catch (e) {
        // 404 → cart doesn’t exist yet
        if (e.code == 404) {
          await createCart(); // your existing helper
          cartDoc = null; // will initialise below
        } else {
          rethrow;
        }
      }

      // 3️⃣ initialise arrays (empty if new cart)
      final List<String> items =
          cartDoc != null ? List<String>.from(cartDoc.data['cartItems']) : [];
      final List<int> qtys =
          cartDoc != null ? List<int>.from(cartDoc.data['qtys']) : [];

      // 4️⃣ add or bump quantity
      final idx = items.indexOf(productId);
      if (idx == -1) {
        items.add(productId);
        qtys.add(1);
      } else {
        qtys[idx] += 1;
      }

      // 5️⃣ write back (create or update)
      final data = CartModel(
        cartId: uid,
        cartItems: items,
        qtys: qtys,
        updatedAt: DateTime.now(),
      ).toMap();

      if (cartDoc == null) {
        // new cart was just created → set initial data
        await _db.updateDocument(
          databaseId: databaseId,
          collectionId: cartCollectionId,
          documentId: uid,
          data: data,
        );
      } else {
        // existing cart → update
        await _db.updateDocument(
          databaseId: databaseId,
          collectionId: cartCollectionId,
          documentId: uid,
          data: data,
        );
      }
    } on AppwriteException catch (e) {
      debugPrint('❌ Appwrite addToCart error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ addToCart failed: $e');
      rethrow;
    }
  }

  /// Retrieves the current [user]'s cart.
  /// Throws if user not logged in or Appwrite errors occur.
  Future<CartModel> getCart() async {
    final uid = await UserServices().getCurrentUid();
    if (uid == null) throw Exception('User not logged in');

    const emptyItems = <String>[];
    const emptyQtys = <int>[];

    try {
      // 🛒 Try fetching the cart
      final doc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: cartCollectionId,
        documentId: uid,
      );

      return CartModel.fromMap(doc.data, doc.$id);
    } on AppwriteException catch (e) {
      // 🧱 If not found, build a blank cart
      if (e.code == 404) {
        await createCart();

        return CartModel(
          cartId: uid,
          cartItems: emptyItems,
          qtys: emptyQtys,
          updatedAt: DateTime.now(),
        );
      }

      rethrow;
    }
  }

// delete cart item
  /// Removes [productId] from the current user’s cart.
  /// If the product isn’t present, the cart is left unchanged.
  /// Throws if user not logged in or Appwrite errors occur.
  Future<void> deleteCartItem(String productId) async {
    final uid = await UserServices().getCurrentUid();
    if (uid == null) throw Exception('User not logged in');

    try {
      // 1️⃣  Grab the cart (docId == uid)
      final doc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: cartCollectionId,
        documentId: uid,
      );

      // 2️⃣  Convert arrays
      final List<String> items = List<String>.from(doc.data['cartItems'] ?? []);
      final List<int> qtys = List<int>.from(doc.data['qtys'] ?? []);

      // 3️⃣  Find the index of productId
      final idx = items.indexOf(productId);
      if (idx == -1) {
        // Product not in cart → nothing to do
        debugPrint('ℹ️ Product $productId not in cart; no deletion.');
        return;
      }

      // 4️⃣  Remove the product + its qty in parallel lists
      items.removeAt(idx);
      qtys.removeAt(idx);

      // 5️⃣  Persist updated cart
      await _db.updateDocument(
        databaseId: databaseId,
        collectionId: cartCollectionId,
        documentId: uid,
        data: {
          'cartItems': items,
          'qtys': qtys,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } on AppwriteException catch (e) {
      debugPrint('❌ Appwrite deleteCartItem error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ deleteCartItem failed: $e');
      rethrow;
    }
  }

  /// Empties the current [user]'s cart (cartItems & qtys → []).
  Future<void> clearCart() async {
    final uid = await UserServices().getCurrentUid();
    if (uid == null) throw Exception('User not logged in');

    try {
      // try update existing cart
      await _db.updateDocument(
        databaseId: databaseId,
        collectionId: cartCollectionId,
        documentId: uid, // uid == cartId
        data: {
          'cartItems': <String>[],
          'qtys': <int>[],
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        // no cart yet – create an empty one
        await createCart(); // your helper builds empty arrays & perms
      } else {
        debugPrint('❌ Appwrite clearCart error: ${e.message}');
        rethrow;
      }
    } catch (e) {
      debugPrint('❌ clearCart failed: $e');
      rethrow;
    }
  }
}
