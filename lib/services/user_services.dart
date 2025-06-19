import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/users.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // register
  Future<void> registerUser(UserModel user, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      )
          .then((val) async {
        if (val.user?.uid != null) {
          await createUser(user);
          Get.snackbar('Success', 'User created successfully');
        } else {
          throw Exception('User not created');
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'User not created');
      rethrow;
    }
  }
  // login

  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar('Error', 'User not logged in');
      rethrow;
    }
  }

  // create user

  Future<void> createUser(UserModel user) async {
    final userCollection = _firestore.collection('users');

    final uid = await getCurrentUid();

    try {
      userCollection.doc(uid).get().then((value) {
        final newUser = UserModel(
          uid: uid,
          name: user.name,
          email: user.email,
          profileImage: user.profileImage,
          address: user.address,
          wishlist: user.wishlist,
          cartID: user.cartID,
          orders: user.orders,
          createdAt: user.createdAt,
        ).toMap();

        if (value.exists) {
          userCollection.doc(uid).update(newUser);
        } else {
          userCollection.doc(uid).set(newUser);
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'User not created');
      rethrow;
    }
  }

  // get uid
  Future<String> getCurrentUid() async => _auth.currentUser!.uid;

  // fetch user

  Future<UserModel> fetchUser() async {
    final uid = await getCurrentUid();
    final userCollection = _firestore.collection('users');
    final userSnapshot = await userCollection.doc(uid).get();
    return UserModel.fromMap(userSnapshot.data()!);
  }

  // update user (detail)

  Future<void> updateUser(UserModel user) async {
    final userCollection = _firestore.collection('users');
    final uid = await getCurrentUid();
    try {
      userCollection.doc(uid).update(user.toMap());
    } catch (e) {
      Get.snackbar('Error', 'User not updated');
      rethrow;
    }
  }

  // isOnline

  Future<bool> isOnline() async =>
      FirebaseAuth.instance.currentUser?.uid != null;
}
