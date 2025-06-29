import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/users.dart';
import '../services/user_services.dart';

class UserController extends GetxController {
  final UserServices userServices;

  UserController({required this.userServices});

  // Observables
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;

      // Step 1: Register user
      final user = await userServices.register(
        email: email,
        password: password,
        name: name,
      );

      await Future.delayed(const Duration(milliseconds: 300)); // 🍃 gentle

      // 👇 Step 2: Login right after registration
      await userServices.login(email: email, password: password);

      await Future.delayed(const Duration(milliseconds: 300)); // 🍃 gentle

      // Step 3: Create user model
      final userModel = UserModel(
        uid: user.$id,
        name: name,
        email: email,
        profileImage: '', // default or upload later
        address: '',
        wishlist: [],
        cartID: '',
        orders: [],
        createdAt: DateTime.now(),
      );

      // Step 4: Save to Appwrite DB with proper permissions
      await userServices.createUser(userModel);

      // Step 5: Store locally
      currentUser.value = userModel;
    } catch (e) {
      debugPrint('❌ Registration Error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // 🔐 Login
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await userServices.login(email: email, password: password);
      await fetchCurrentUser();
    } catch (e) {
      debugPrint('❌ Login Error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // 🧠 Fetch Current User
  Future<UserModel?> fetchCurrentUser() async {
    try {
      isLoading.value = true;
      final user = await userServices.fetchUser();
      currentUser.value = user;
      return user;
    } catch (e) {
      debugPrint('❌ Fetch User Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // 🛠️ Update User
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await userServices.updateUser(updatedUser);
      currentUser.value = updatedUser;
    } catch (e) {
      debugPrint('❌ Update User Error: $e');
      rethrow;
    }
  }

  // 🔍 Check if Logged In
  Future<bool> isOnline() async {
    return await userServices.isOnline();
  }

  // 🔌 Get UID
  Future<String?> getCurrentUid() async {
    return await userServices.getCurrentUid();
  }

  // 🚪 Logout
  Future<void> logoutUser() async {
    try {
      await userServices.logout();
      currentUser.value = null;
    } catch (e) {
      debugPrint('❌ Logout Error: $e');
    }
  }
}
