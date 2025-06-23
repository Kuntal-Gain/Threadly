import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

import '../models/users.dart';
import '../views/utils/constants/appwrite.dart';

class UserServices {
  final Client _client = Client()
    ..setEndpoint(APPWRITE_ENDPOINT) // or your local server
    ..setProject(APPWRITE_PROJECT_ID); // <- Replace with actual project ID

  late final Account _account = Account(_client);
  late final Databases _db = Databases(_client);

  // 🔐 Register
  Future<models.User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  // 🔐 Login
  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    return await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  // 🆔 Get UID
  Future<String?> getCurrentUid() async {
    try {
      final user = await _account.get();
      return user.$id;
    } catch (_) {
      return null;
    }
  }

  // 📥 Create User Document
  Future<void> createUser(UserModel user) async {
    try {
      await _db.createDocument(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        documentId: user.uid, // use same ID as account.$id
        data: user.toMap(),
        permissions: [
          Permission.read(Role.user(user.uid)),
          Permission.write(Role.user(user.uid)),
        ],
      );

      print("✅ User document created for ${user.email}");
    } on AppwriteException catch (e) {
      print("❌ Appwrite Error: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unknown Error: $e");
      rethrow;
    }
  }

  // 📤 Fetch User Document
  Future<UserModel?> fetchUser() async {
    try {
      final uid = await getCurrentUid();
      if (uid == null) return null;

      final doc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        documentId: uid,
      );

      return UserModel.fromMap(doc.data);
    } catch (e) {
      print('❌ Failed to fetch user: $e');
      return null;
    }
  }

  // ♻️ Update User Document
  Future<void> updateUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: databaseId,
        collectionId: usersCollection,
        documentId: user.uid,
        data: user.toMap(),
      );
    } catch (e) {
      print('❌ Failed to update user: $e');
      rethrow;
    }
  }

  // 👀 Is User Online (logged in)
  Future<bool> isOnline() async {
    try {
      await _account.get();
      return true;
    } catch (_) {
      return false;
    }
  }

  // 🚪 Logout
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}
  }
}
