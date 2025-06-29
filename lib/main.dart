import 'package:appwrite/appwrite.dart';
import 'package:clozet/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'views/routes/app_routes.dart';
import 'views/utils/constants/appwrite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client()
      .setEndpoint("https://nyc.cloud.appwrite.io/v1")
      .setProject(APPWRITE_PROJECT_ID);
  Account account = Account(client);

  debugPrint(account.get().toString());

  runApp(GetMaterialApp(
    // home: const ProductDetailsScreen(productID: "685a7cb90028a84a655a"),
    initialBinding: AppBinding(),
    getPages: AppRoutes.routes,
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
  ));
}
