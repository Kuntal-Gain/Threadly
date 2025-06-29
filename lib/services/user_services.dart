import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';

import '../models/users.dart';
import '../views/utils/constants/appwrite.dart';

class UserServices {
  final Client _client = Client()
    ..setEndpoint(APPWRITE_ENDPOINT)
    ..setProject(APPWRITE_PROJECT_ID);

  late final Account _account = Account(_client);
  late final Databases _db = Databases(_client);
  late final Storage _storage = Storage(_client);

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

      debugPrint("✅ User document created for ${user.email}");
    } on AppwriteException catch (e) {
      debugPrint("❌ Appwrite Error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unknown Error: $e");
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
      debugPrint('❌ Failed to fetch user: $e');
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
      debugPrint('❌ Failed to update user: $e');
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

  // upload image
  Future<String> uploadImage({required String path}) async {
    try {
      final result = await _storage.createFile(
        bucketId: storageBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: path),
      );

      // This generates a previewable image URL
      final url = _storage
          .getFilePreview(
            bucketId: storageBucketId,
            fileId: result.$id,
          )
          .toString();

      return url;
    } catch (e) {
      debugPrint('❌ Failed to upload image: $e');
      rethrow;
    }
  }
}
