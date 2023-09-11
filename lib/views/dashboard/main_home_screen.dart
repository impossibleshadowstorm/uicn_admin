import 'package:uicn_admin/services/global.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/main_application_controller.dart';
import '../../../../utils/constants.dart';
import '../drawer_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final MainApplicationController _mainApplicationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DrawerScreen(),
        Obx(() {
          return AnimatedContainer(
            transform: Matrix4.translationValues(
                _mainApplicationController.xOffset.value,
                _mainApplicationController.yOffset.value,
                0)
              ..scale(
                  _mainApplicationController.isDrawerOpen.value ? 0.85 : 1.00)
              ..rotateZ(
                  _mainApplicationController.isDrawerOpen.value ? -50 : 0),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _mainApplicationController.isDrawerOpen.value
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: Scaffold(
              body: _mainApplicationController.bottomNavScreens[
                  _mainApplicationController.bottomNavIdx.value],
              backgroundColor: Constants.lightBackgroundColor,
              bottomNavigationBar: CurvedNavigationBar(
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Constants.lightBackgroundColor,
                onTap: (index) {
                  _mainApplicationController.bottomNavIdx.value = index;
                },
                buttonBackgroundColor: Constants.primaryDarkBlueColor,
                index: _mainApplicationController.bottomNavIdx.value,
                color: Constants.primaryColor,
                items: const [
                  Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
