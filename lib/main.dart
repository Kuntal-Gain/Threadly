import 'package:appwrite/appwrite.dart';
import 'package:clozet/dependency_injection.dart';
import 'package:clozet/views/screens/auth/auth_screen.dart';
import 'package:clozet/views/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'views/routes/app_routes.dart';
import 'views/utils/constants/appwrite.dart';
import 'views/utils/widgets/redirection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client()
      .setEndpoint("https://nyc.cloud.appwrite.io/v1")
      .setProject(APPWRITE_PROJECT_ID);
  Account account = Account(client);

  if (kDebugMode) {
    print(account);
  }

  runApp(GetMaterialApp(
    initialBinding: AppBinding(),
    getPages: AppRoutes.routes,
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
  ));
}
