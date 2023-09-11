import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/common/custom_toasts.dart';
import 'package:uicn_admin/common/widgets/common_button.dart';
import 'package:uicn_admin/common/widgets/custom_dropdown.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/controllers/notification/notification_controller.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:uicn_admin/views/dashboard/main_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChooseNotificationCriteriaScreen extends StatefulWidget {
  final String title;
  final String message;
  final String links;

  const ChooseNotificationCriteriaScreen({
    super.key,
    required this.title,
    required this.message,
    required this.links,
  });

  @override
  State<ChooseNotificationCriteriaScreen> createState() =>
      _ChooseNotificationCriteriaScreenState();
}

class _ChooseNotificationCriteriaScreenState
    extends State<ChooseNotificationCriteriaScreen> {
  final MainApplicationController _mainApplicationController = Get.find();
  final NotificationController _notificationController =
      Get.put(NotificationController());

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(Global.storageServices.getString(Constants.courseCode));
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            Container(height: AppBar().preferredSize.height),
            SizedBox(
              height: AppBar().preferredSize.height,
              width: 100.w,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: Constants.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      "Choose Criteria",
                      style: GoogleFonts.openSans(
                        color: Constants.darkBlackTextColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Year",
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return InkWell(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                onTap: () {
                                  _notificationController.selectedYear.value =
                                      index;
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                      ),
                                      child: Obx(() {
                                        return Container(
                                          color: _notificationController
                                                      .selectedYear.value ==
                                                  index
                                              ? Colors.black
                                              : Colors.transparent,
                                        );
                                      }),
                                    ),
                                    SizedBox(width: 2.5.w),
                                    Text(
                                      index == 0
                                          ? "All"
                                          : index == 1
                                              ? "${DateTime.now().year - 1}"
                                              : index == 2
                                                  ? "${DateTime.now().year}"
                                                  : "${DateTime.now().year + 1}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                  // Courses Selection
                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Courses",
                          style: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Global.storageServices.getString(Constants.position) ==
                                "Additional Director"
                            ? InkWell(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                onTap: () {
                                  _notificationController.selectedToSend.value =
                                      Constants.everyone;
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                      ),
                                      child: Container(
                                          color: _notificationController
                                                      .selectedToSend.value ==
                                                  "ALL"
                                              ? Colors.black
                                              : Colors.transparent),
                                    ),
                                    SizedBox(width: 2.5.w),
                                    Text(
                                      "Everyone",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: 2.5.h),

                        // All PG Column
                        Global.storageServices.getString(Constants.position) ==
                                    "Additional Director" ||
                                (Global.storageServices
                                            .getString(Constants.position) ==
                                        "Head Of Department" &&
                                    Global.storageServices
                                            .getString(Constants.courseCode) ==
                                        "PG")
                            ? Column(
                                children: [
                                  InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    onTap: () {
                                      _notificationController.selectedToSend
                                          .value = Constants.allPG;
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 0.5),
                                          ),
                                          child: Container(
                                            color: _notificationController
                                                        .selectedToSend.value ==
                                                    Constants.allPG
                                                ? Colors.black
                                                : Colors.transparent,
                                          ),
                                        ),
                                        SizedBox(width: 2.5.w),
                                        Text(
                                          "All PG",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                    height: _notificationController
                                            .notificationCriteria["PG"].length *
                                        25.0,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _notificationController
                                            .notificationCriteria["PG"].length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 25,
                                            child: InkWell(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              onTap: () {
                                                _notificationController
                                                        .selectedToSend.value =
                                                    _notificationController
                                                            .notificationCriteria[
                                                        "PG"][index]["code"];
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.5),
                                                    ),
                                                    child: Container(
                                                        color: _notificationController
                                                                    .selectedToSend
                                                                    .value ==
                                                                _notificationController
                                                                            .notificationCriteria[
                                                                        "PG"][index]
                                                                    ["code"]
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent),
                                                  ),
                                                  SizedBox(width: 2.5.w),
                                                  Text(
                                                    _notificationController
                                                                    .notificationCriteria[
                                                                "PG"][index]
                                                            ["displayValue"] ??
                                                        "",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : const SizedBox(),

                        SizedBox(height: 2.5.h),
                        //   All UG Column
                        Global.storageServices.getString(Constants.position) ==
                                    "Additional Director" ||
                                (Global.storageServices
                                            .getString(Constants.position) ==
                                        "Head Of Department" &&
                                    Global.storageServices
                                            .getString(Constants.courseCode) ==
                                        "UG")
                            ? Column(
                                children: [
                                  InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    onTap: () {
                                      _notificationController.selectedToSend
                                          .value = Constants.allUG;
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 0.5),
                                          ),
                                          child: Container(
                                            color: _notificationController
                                                        .selectedToSend.value ==
                                                    Constants.allUG
                                                ? Colors.black
                                                : Colors.transparent,
                                          ),
                                        ),
                                        SizedBox(width: 2.5.w),
                                        Text(
                                          "All UG",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                    height: _notificationController
                                            .notificationCriteria["UG"].length *
                                        25.0,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _notificationController
                                            .notificationCriteria["UG"].length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 25,
                                            child: InkWell(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              onTap: () {
                                                _notificationController
                                                        .selectedToSend.value =
                                                    _notificationController
                                                            .notificationCriteria[
                                                        "UG"][index]["code"];
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.5),
                                                    ),
                                                    child: Container(
                                                        color: _notificationController
                                                                    .selectedToSend
                                                                    .value ==
                                                                _notificationController
                                                                            .notificationCriteria[
                                                                        "UG"][index]
                                                                    ["code"]
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent),
                                                  ),
                                                  SizedBox(width: 2.5.w),
                                                  Text(
                                                    _notificationController
                                                                    .notificationCriteria[
                                                                "UG"][index]
                                                            ["displayValue"] ??
                                                        "",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    );
                  }),
                ],
              ),
            ),
            Obx(
              () => _mainApplicationController.addNotificationLoading.value
                  ? CommonButton.primaryFilledProgressButton(null, null)
                  : InkWell(
                      onTap: () async {
                        if (_notificationController.selectedToSend.value ==
                            "") {
                          CustomToasts.errorToast(
                              context, "Please Select Courses to send..");
                        } else {
                          int response = await _mainApplicationController
                              .uploadFilesToFirebase(
                                  _mainApplicationController.filesList);

                          if (response == 404) {
                            if (mounted) {
                              CustomToasts.errorToast(
                                  context, "Unable to upload files.!");
                            }
                          } else {
                            int newResponse = await _mainApplicationController
                                .addNotification(
                                    title: widget.title,
                                    message: widget.message,
                                    listOfFilesUrl: _mainApplicationController
                                        .uploadedFileUrls,
                                    links: widget.links,
                                    sendTo: _notificationController
                                        .selectedToSend.value,
                                    year: _notificationController
                                        .selectedYear.value);

                            if (newResponse == 2) {
                              if (mounted) {
                                CustomToasts.successToast(context,
                                    "Notification added SuccessFully.!");
                              }
                              _mainApplicationController.uploadedFileUrls
                                  .clear();
                              Get.offAll(() => const MainHomeScreen());
                            } else {
                              if (mounted) {
                                CustomToasts.errorToast(
                                    context, "Unable to create notification!");
                              }
                            }
                          }
                        }
                      },
                      child: CommonButton.primaryFilledButton(
                          null, null, "Add Notification"),
                    ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
