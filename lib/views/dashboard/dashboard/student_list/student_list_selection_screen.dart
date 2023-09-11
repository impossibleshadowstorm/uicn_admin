import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:uicn_admin/views/dashboard/dashboard/student_list/student_list_screen.dart';

import '../../../../services/global.dart';

class StudentListSelectionScreen extends StatefulWidget {
  const StudentListSelectionScreen({super.key});

  @override
  State<StudentListSelectionScreen> createState() =>
      _StudentListSelectionScreenState();
}

class _StudentListSelectionScreenState
    extends State<StudentListSelectionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height),
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
                      "Students",
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
              child: FutureBuilder(
                  future: _firestore
                      .collection(Constants.admin)
                      .doc(Global.storageServices.getString(Constants.docId))
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.data()!.isNotEmpty) {
                        List<String> sectionList = [];

                        for (String item in snapshot.data!.data()!["section"]) {
                          sectionList.add(item);
                        }
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: sectionList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(height: 2.5.h),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => StudentListScreen(section: sectionList[index]));
                                    },
                                    child: Container(
                                      width: 100.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 2.5.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(1.5.w),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Constants.primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            height: 70,
                                            width: 70,
                                            child: Center(
                                              child: Text(
                                                sectionList[index],
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  sectionList[index],
                                                  style: GoogleFonts.montserrat(
                                                    color:
                                                        Constants.primaryColor,
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_sharp,
                                                  color: Constants.primaryColor,
                                                  size: 20.sp,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  index == sectionList.length - 1
                                      ? SizedBox(height: 5.h)
                                      : const SizedBox(),
                                ],
                              );
                            });
                      }
                      return Center(
                        child: Text(
                          "Sections are missing..!!",
                          style: GoogleFonts.poppins(
                            color: Constants.primaryColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Constants.primaryColor,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
