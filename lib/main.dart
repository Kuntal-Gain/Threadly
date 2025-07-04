import 'package:appwrite/appwrite.dart';
import 'package:clozet/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'views/routes/app_routes.dart';
import 'views/screens/order/checkout_screen.dart';
import 'views/screens/order/orders_screen.dart';
import 'views/utils/constants/appwrite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client =
      Client().setEndpoint(APPWRITE_ENDPOINT).setProject(APPWRITE_PROJECT_ID);
  Account account = Account(client);

  debugPrint(account.get().toString());

  runApp(GetMaterialApp(
    home: const OrderScreen(userId: "68583fc87f966d599ee6"),
    initialBinding: AppBinding(),
    getPages: AppRoutes.routes,
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
  ));
}
