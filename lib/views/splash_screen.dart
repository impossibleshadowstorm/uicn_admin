import 'dart:async';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/views/dashboard/main_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/main_animation_controller.dart';
import '../services/global.dart';
import '../utils/constants.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final MainAnimationController _mainAnimationController = Get.find();
  final MainApplicationController _mainApplicationController = Get.find();

  late Animation animation;
  late AnimationController controller;
  late GravitySimulation simulation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    simulation = GravitySimulation(
      100.0, // acceleration
      0.0, // starting point
      50.h - 70, // end point
      1500.0, // starting velocity
    );

    controller = AnimationController(
        vsync: this,
        upperBound: 50.h - 70,
        duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });

    controller.animateWith(simulation);
    // Global.storageServices.removeAllData();
    checkForScreens();
  }

  loadPermissions() {}

  checkForScreens() {
    // print(Global.storageServices.getString(Constants.eid));
    // print(Global.storageServices.getString(Constants.courseCode));
    // print(Global.storageServices.getString(Constants.position));
    if (Global.storageServices.getString(Constants.docId) != null &&
        Global.storageServices.getString(Constants.courseCode) != null &&
        Global.storageServices.getString(Constants.position) != null) {
      Timer(
        const Duration(seconds: 3),
        () => Get.offAll(
          () => const MainHomeScreen(),
          transition: Transition.leftToRight,
          curve: Curves.easeInOutQuad,
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Get.offAll(
          () => const LoginScreen(),
          transition: Transition.leftToRight,
          curve: Curves.easeInOutQuad,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Stack(
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: Column(
                children: [
                  Container(
                    height: 50.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff111B31),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(35.w),
                        bottomLeft: Radius.circular(35.w),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        Text(
                          "UIC Notifier",
                          style: GoogleFonts.timmana(
                            color: const Color(0xff111B31),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Admin",
                          style: GoogleFonts.timmana(
                              color: const Color(0xff111B31),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              // top: 50.h - 70,
              top: controller.value,
              left: 50.w - 70,
              child: InkWell(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png')),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 6.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
