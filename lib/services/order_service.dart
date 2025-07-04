import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:clozet/models/order.dart';
import 'package:clozet/views/utils/constants/appwrite.dart';

class OrderService {
  final Client _client = Client()
    ..setEndpoint(APPWRITE_ENDPOINT)
    ..setProject(APPWRITE_PROJECT_ID);

  late final Databases _db = Databases(_client);

  /// This method will create [OrderModel] in the database
  Future<OrderModel> createOrder(OrderModel order) async {
    final Document doc = await _db.createDocument(
      databaseId: databaseId,
      collectionId: ordersCollectionId,
      documentId: order.orderId,
      data: order.toMap(),
      permissions: [
        Permission.read(Role.user(order.userId)),
        Permission.write(Role.user(order.userId)),
      ],
    );
    return OrderModel.fromMap(doc.data, doc.$id);
  }

  /// This method will fetch all [OrderModel] for a user
  Future<List<OrderModel>> fetchOrders(String userId) async {
    final DocumentList docs = await _db.listDocuments(
      databaseId: databaseId,
      collectionId: ordersCollectionId,
      queries: [
        Query.equal('userId', userId),
      ],
    );

    return docs.documents
        .map((d) => OrderModel.fromMap(d.data, d.$id))
        .toList();
  }

  /// This method will fetch a single [OrderModel]
  Future<OrderModel?> fetchOrderById(String orderId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: ordersCollectionId,
        documentId: orderId,
      );

      return OrderModel.fromMap(doc.data, doc.$id);
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      rethrow;
    }
  }

  /// This method will cancel an [OrderModel]
  Future<void> cancelOrder(String orderId) async {
    final order = await fetchOrderById(orderId);
    if (order == null) {
      throw Exception('Order not found');
    }

    // append a "Cancelled" status
    final updatedStatuses = List<String>.from(order.statuses)..add('Cancelled');

    await _db.updateDocument(
      databaseId: databaseId,
      collectionId: ordersCollectionId,
      documentId: orderId,
      data: {
        'statuses': updatedStatuses,
      },
    );
  }
}
