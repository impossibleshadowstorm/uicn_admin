import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/views/auth/login_screen.dart';
import 'package:uicn_admin/views/dashboard/main_home_screen.dart';

import '../utils/constants.dart';
import 'dashboard/dashboard/faculty_list/faculty_list_screen.dart';
import 'dashboard/dashboard/student_list/student_list_selection_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final MainApplicationController _mainApplicationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Constants.lightBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.5.w),
                      FutureBuilder(
                          future: _firebaseFirestore
                              .collection(Constants.admin)
                              .doc(Global.storageServices
                                  .getString(Constants.docId))
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.data()!["name"],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return SizedBox(
                              height: 20,
                              width: 50.w,
                              child: const LinearProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Column(
                    children: [
                      InkWell(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _mainApplicationController.xOffset.value = 0.0;
                          _mainApplicationController.yOffset.value = 0.0;
                          _mainApplicationController.isDrawerOpen.value = false;
                          _mainApplicationController.bottomNavIdx.value = 1;
                          Get.to(() => const MainHomeScreen());
                        },
                        child: menuTile(Icons.notifications, "Notifications"),
                      ),
                      SizedBox(height: 2.5.w),
                      InkWell(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _mainApplicationController.xOffset.value = 0.0;
                          _mainApplicationController.yOffset.value = 0.0;
                          _mainApplicationController.isDrawerOpen.value = false;
                          _mainApplicationController.bottomNavIdx.value = 1;

                          if (Global.storageServices
                                  .getString(Constants.position) ==
                              Constants.ad) {
                            Get.to(() =>
                                const FacultyListScreen(role: Constants.ad));
                          } else if (Global.storageServices
                                  .getString(Constants.position) ==
                              Constants.hod) {
                            Get.to(() =>
                                const FacultyListScreen(role: Constants.hod));
                          } else {
                            // Get.to(() => const StudentListSelectionScreen());
                          }
                        },
                        child: menuTile(
                          Icons.info_outline,
                          Global.storageServices
                                          .getString(Constants.position) ==
                                      Constants.ad ||
                                  Global.storageServices
                                          .getString(Constants.position) ==
                                      Constants.hod
                              ? "Faculty List"
                              : "Students List",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      _mainApplicationController.xOffset.value = 0.0;
                      _mainApplicationController.yOffset.value = 0.0;
                      _mainApplicationController.isDrawerOpen.value = false;
                      Global.storageServices.removeAllData();
                      Get.to(() => const LoginScreen());
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.cancel,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        SizedBox(width: 2.5.w),
                        Text(
                          'Log out',
                          style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.5)),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget menuTile(IconData iconData, String menuName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          color: Colors.white,
          size: 20.sp,
        ),
        SizedBox(width: 5.w),
        Text(
          menuName.toUpperCase(),
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 2),
        )
      ],
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const NewRow({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
