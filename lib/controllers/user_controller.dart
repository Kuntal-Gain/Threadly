import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/users.dart';
import '../services/user_services.dart';
import '../views/utils/constants/generators.dart';

class UserController extends GetxController {
  final UserServices userServices;

  UserController({required this.userServices});

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  /// 🔐 Register user
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      // Create Firebase user
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = result.user!.uid;

      // Build user model
      final user = UserModel(
        uid: uid,
        name: name,
        email: email,
        profileImage: '',
        address: '',
        wishlist: [],
        cartID: generateCartId(),
        orders: [],
        createdAt: DateTime.now(),
      );

      // Save in Firestore
      await userServices.createUser(user);

      // Update local state
      currentUser.value = user;

      Get.snackbar("Success", "Registered successfully 🎉");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔑 Login user
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      await userServices.loginUser(email, password);
      await fetchCurrentUser();

      Get.snackbar("Success", "Logged in successfully 🚀");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 📥 Fetch user from Firestore
  Future<void> fetchCurrentUser() async {
    try {
      final userData = await userServices.fetchUser();
      currentUser.value = userData;
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data");
    }
  }

  /// 📝 Update profile
  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      await userServices.updateUser(updatedUser);
      currentUser.value = updatedUser;
      Get.snackbar("Updated", "Profile updated 💾");
    } catch (e) {
      Get.snackbar("Error", "Update failed ❌");
    }
  }

  /// 📝 Check if user is online
  Future<bool> isOnline() async => userServices.isOnline();

  // /// 🚪 Logout
  // Future<void> logout() async {
  //   await _userServices.signOut();
  //   currentUser.value = null;
  //   Get.offAllNamed('/login'); // optional routing
  // }
}
