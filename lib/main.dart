import 'package:admin/screens/auth/login_screen.dart';
import 'package:admin/controllers/project_controller.dart';
import 'package:admin/controllers/feedback_controller.dart';
import 'package:admin/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'screens/dashboard/dashboard_screen.dart';


Widget defaultHomePage = LoginScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Register controllers globally so they persist across all screens
  Get.put(LoginController(), permanent: true);
  Get.put(ProjectController(), permanent: true);
  Get.put(FeedbackController(), permanent: true);

  final box = GetStorage();
  String? token = box.read('token');

  if (token != null) {
    defaultHomePage = DashboardScreen();
  }

  runApp(const ProjexHubAdmin());
}


class ProjexHubAdmin extends StatelessWidget {
  const ProjexHubAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ProjexHub Admin",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: defaultHomePage,
    );
  }
}