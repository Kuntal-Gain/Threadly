import 'package:clozet/controllers/product_controller.dart';
import 'package:clozet/controllers/user_controller.dart';
import 'package:clozet/services/product_services.dart';
import 'package:clozet/services/user_services.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // users
    Get.lazyPut(() => UserServices());
    Get.lazyPut(() => UserController(userServices: Get.find()));

    // products
    Get.lazyPut(() => ProductServices());
    Get.lazyPut(() => ProductController(productServices: Get.find()));
  }
}
