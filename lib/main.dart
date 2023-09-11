import 'package:uicn_admin/controllers/main_animation_controller.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/views/auth/login_screen.dart';
import 'package:uicn_admin/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:uicn_admin/services/global.dart';

void main() async{
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  MainAnimationController mainAnimationController = Get.put(MainAnimationController());
  MainApplicationController mainApplicationController = Get.put(MainApplicationController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, type){
      return GetMaterialApp(
        title: 'UIC Notifier Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      );
    });
  }
}