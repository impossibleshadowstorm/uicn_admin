import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/common/functions/class%20Functions.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:uicn_admin/views/dashboard/dashboard/faculty_list/faculty_list_screen.dart';
import 'package:uicn_admin/views/dashboard/dashboard/student_list/student_list_screen.dart';
import 'package:uicn_admin/views/dashboard/dashboard/student_list/student_list_selection_screen.dart';
import 'package:uicn_admin/views/dashboard/notification/create_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MainApplicationController _mainApplicationController = Get.find();
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Global.storageServices.getString(Constants.position) !=
        "Additional Director") {
      _mainApplicationController.getFinalizationData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightBackgroundColor,
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height),
            SizedBox(
              height: AppBar().preferredSize.height,
              child: Row(
                children: [
                  Obx(() {
                    return InkWell(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        if (_mainApplicationController.isDrawerOpen.value) {
                          _mainApplicationController.xOffset.value = 0.0;
                          _mainApplicationController.yOffset.value = 0.0;
                          _mainApplicationController.isDrawerOpen.value = false;
                        } else {
                          _mainApplicationController.xOffset.value = 290.0;
                          _mainApplicationController.yOffset.value = 80.0;
                          _mainApplicationController.isDrawerOpen.value = true;
                        }
                      },
                      child: Icon(
                        _mainApplicationController.isDrawerOpen.value
                            ? Icons.arrow_back_sharp
                            : Icons.menu,
                        color: Constants.primaryColor,
                        size: 20.sp,
                      ),
                    );
                  })
                ],
              ),
            ),
            FutureBuilder(
                future: firebaseFireStore
                    .collection(Constants.admin)
                    .doc(Global.storageServices.getString(Constants.docId))
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _mainApplicationController.localEid =
                        snapshot.data!.data()!["eid"];
                    return Container(
                      width: 100.w,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            snapshot.data!.data()!['name'].toString(),
                            style: GoogleFonts.openSans(
                              color: Constants.darkBlackTextColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            snapshot.data!
                                .data()!['role']['position']
                                .toString(),
                            style: GoogleFonts.openSans(
                              color: Constants.darkBlackTextColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Constants.primaryColor,
                    ),
                  );
                }),
            SizedBox(height: 2.5.h),
            Row(
              children: [
                Container(
                  width: 35.w,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.5.w),
                  ),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
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
                            Get.to(() => const StudentListSelectionScreen());
                          }
                        },
                        child: Container(
                          width: 35.w,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.w, horizontal: 5.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                Global.storageServices
                                            .getString(Constants.position) ==
                                        "Additional Director"
                                    ? "Faculty List"
                                    : "Student List",
                                style: GoogleFonts.openSans(
                                  color: Constants.darkBlackTextColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/avatar.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Global.storageServices.getString(Constants.position) !=
                              "Additional Director"
                          ? Obx(() {
                              return _mainApplicationController.finalized.value
                                  ? const SizedBox()
                                  : Positioned(
                                      child: Container(
                                        width: 35.w,
                                        height: 150,
                                        color: Colors.grey.withOpacity(0.2),
                                        child: Center(
                                          child: Icon(
                                            Icons.lock,
                                            color: Colors.black,
                                            size: 30.sp,
                                          ),
                                        ),
                                      ),
                                    );
                            })
                          : const SizedBox(),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const CreateNotificationScreen());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.5.w),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Create Notification",
                            style: GoogleFonts.openSans(
                              color: Constants.darkBlackTextColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("assets/images/notify.jpeg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
