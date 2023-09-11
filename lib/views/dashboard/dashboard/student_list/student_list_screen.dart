import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uicn_admin/controllers/student_list_controller/student_list_controller.dart';
import 'package:uicn_admin/utils/constants.dart';
import '../../../../services/global.dart';

class StudentListScreen extends StatefulWidget {
  final String section;

  const StudentListScreen({super.key, required this.section});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentListController _studentListController =
      Get.put(StudentListController());

  @override
  void initState() {
    super.initState();
    _studentListController.fetchStudentData(widget.section);
  }

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
            Obx(
              () => _studentListController.studentList.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      child: TextFormField(
                        cursorHeight: 16.sp,
                        controller: _studentListController.searchUidController,
                        onChanged: (val) {
                          _studentListController.filterStudentData(
                              val, widget.section);
                        },
                        cursorColor: Constants.primaryColor,
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Constants.darkBlackTextColor,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Constants.primaryColor,
                            size: 17.sp,
                          ),
                          hintText: "Search UID",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Obx(() {
                return _studentListController.searching.value == false &&
                        _studentListController.studentList.isEmpty
                    ? Center(
                        child: Text(
                          "No Student in ${widget.section}..!!",
                          style: GoogleFonts.poppins(
                            color: Constants.primaryColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _studentListController.searching.value
                            ? _studentListController.filteredStudentList.length
                            : _studentListController.studentList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(height: 2.5.h),
                              InkWell(
                                onTap: () {
                                  // open popup for password change
                                },
                                child: Container(
                                  width: 100.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.5.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1.5.w),
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
                                            "l",
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _studentListController
                                                          .searching.value
                                                      ? _studentListController
                                                                  .filteredStudentList[
                                                              index]["name"] ??
                                                          ""
                                                      : _studentListController
                                                                  .studentList[
                                                              index]["name"] ??
                                                          "",
                                                  style: GoogleFonts.montserrat(
                                                    color:
                                                        Constants.primaryColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "UID: ${_studentListController.searching.value ? _studentListController.filteredStudentList[index]["uid"] ?? "" : _studentListController.studentList[index]["uid"]}",
                                                  style: GoogleFonts.montserrat(
                                                    color:
                                                        Constants.primaryColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down_sharp,
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
                            ],
                          );
                        });
              }),
              //     }
              //     return Center(
              //       child: Text(
              //         "No Student in ${widget.section}..!!",
              //         style: GoogleFonts.poppins(
              //           color: Constants.primaryColor,
              //           fontSize: 17.sp,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     );
              //   }
              //   return Center(
              //     child: CircularProgressIndicator(
              //       color: Constants.primaryColor,
              //     ),
              //   );
              // }),
            ),
            SizedBox(height: AppBar().preferredSize.height),
          ],
        ),
      ),
    );
  }
}
