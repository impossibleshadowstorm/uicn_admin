import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/common/custom_toasts.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:uicn_admin/views/dashboard/notification/update/update_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final MainApplicationController _mainApplicationController = Get.find();
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
              width: 100.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return InkWell(
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
                  }),
                  Text(
                    "Notifications",
                    style: GoogleFonts.openSans(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 1.5.w),
                ],
              ),
            ),
            SizedBox(height: .5.h),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.w),
                border: Border.all(color: Constants.lightBackgroundColor),
              ),
              child: TextFormField(
                style: GoogleFonts.poppins(
                  fontSize: 16.5.sp,
                  color: Colors.black,
                ),
                cursorHeight: 15,
                cursorColor: Constants.primaryColor,
                decoration: InputDecoration(
                  hintText: "Search Title",
                  hintStyle: GoogleFonts.poppins(
                    color: Constants.darkGreyTextColor,
                    fontSize: 16.5.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 2.5.w),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Constants.primaryColor,
                    size: 17.5.sp,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.5.w, horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.5.w),
                      border: Border.all(color: Constants.lightGreyBorderColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Filter",
                          style: GoogleFonts.openSans(
                            color: Colors.black54,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 1.5.w),
                        Icon(
                          Icons.filter_list_sharp,
                          color: Colors.black54,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                width: 100.w,
                                height: 45.h,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 7.5.w),
                                // Customize your bottom sheet content here
                                child: Column(
                                  children: [
                                    Text(
                                      "Sort By",
                                      style: GoogleFonts.roboto(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ));
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.w, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.5.w),
                        border:
                            Border.all(color: Constants.lightGreyBorderColor),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Sort",
                            style: GoogleFonts.openSans(
                              color: Colors.black54,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 1.5.w),
                          Icon(
                            Icons.sort_sharp,
                            color: Colors.black54,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Constants.lightGreyTextColor,
              height: 1.h,
            ),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  setState(() {});
                },
                child: FutureBuilder(
                    future: firebaseFireStore
                        .collection(Constants.notifications)
                        .where('docId',
                            isEqualTo: Global.storageServices
                                .getString(Constants.docId))
                        .orderBy('updatedAt', descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(height: 1.5.h),
                                  InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    onTap: () {
                                      Get.to(() => UpdateNotificationScreen(
                                          id: snapshot.data!.docs[index].id));
                                    },
                                    child: notificationTile(
                                        snapshot.data!.docs[index].data(),
                                        snapshot.data!.docs[index].id),
                                  ),
                                  index == snapshot.data!.docs.length - 1
                                      ? SizedBox(height: 5.h)
                                      : const SizedBox(),
                                ],
                              );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Constants.primaryColor,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationTile(var data, String id) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5.w),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data["title"] ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Column(
                children: [
                  Text(
                    "${data["creationDate"]}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    "${data["creationTime"]}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 100.w,
                  child: Text(
                    data["message"].toString().replaceAll(r"\n", "\n"),
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  try {
                    firestore
                        .collection(Constants.notifications)
                        .doc(id)
                        .delete();

                    CustomToasts.errorToast(
                        context, "Notification has been deleted for everyone!");
                    // setState(() {});
                    _refreshIndicatorKey.currentState?.show();
                  } catch (e) {
                    CustomToasts.errorToast(context,
                        "Unable to delete this notification. Try again Later!");
                  }
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Constants.primaryColor,
                  size: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
