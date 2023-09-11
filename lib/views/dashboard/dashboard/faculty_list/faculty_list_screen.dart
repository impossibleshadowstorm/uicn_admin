import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:uicn_admin/views/dashboard/dashboard/faculty_list/create_faculty_screen.dart';
import '../../../../utils/constants.dart';

class FacultyListScreen extends StatefulWidget {
  final String role;

  const FacultyListScreen({
    super.key,
    required this.role,
  });

  @override
  State<FacultyListScreen> createState() => _FacultyListScreenState();
}

class _FacultyListScreenState extends State<FacultyListScreen> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

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
              width: 100.w,
              child: Row(
                children: [
                  InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
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
                      "Faculties",
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FutureBuilder(
                  future: _fireStore.collection(Constants.admin).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final documents = snapshot.data!.docs;

                      // Filter data based on position
                      final academicCoordinators = <Map<String, dynamic>>[];
                      final headsOfDepartment = <Map<String, dynamic>>[];

                      for (final doc in documents) {
                        final data = doc.data();
                        final position = data['role']['position'];

                        if (position == Constants.coordinator) {
                          academicCoordinators.add({
                            ...data,
                            'docId': doc.id,
                          });
                        } else if (position == Constants.hod) {
                          headsOfDepartment.add({
                            ...data,
                            'docId': doc.id,
                          });
                        }
                      }

                      return Column(
                        children: [
                          facultyListTitle("Heads Of Department"),
                          SizedBox(height: 2.5.w),
                          SizedBox(
                            height:
                                (headsOfDepartment.length * (70 + 2.h)) + 20,
                            width: 100.w,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: headsOfDepartment.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      facultyListTile(headsOfDepartment[index]),
                                      SizedBox(height: 2.5.w),
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(height: 5.h),
                          facultyListTitle(Constants.coordinator),
                          SizedBox(height: 2.5.w),
                          SizedBox(
                            height:
                                (academicCoordinators.length * (70 + 2.h)) + 20,
                            width: 100.w,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: academicCoordinators.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      facultyListTile(
                                          academicCoordinators[index]),
                                      SizedBox(height: 2.5.w),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Constants.primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Get.to(() => const CreateFacultyScreen());
        },
        backgroundColor: Constants.primaryColor,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget facultyListTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget facultyListTile(Map<String, dynamic> data) {
    return Container(
      height: 70 + 2.h,
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.w),
          bottomRight: Radius.circular(25.w),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(.5.w),
            ),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["name"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Constants.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "20${data['docId'].toString().substring(0, 2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Constants.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${Constants.courseList[data["role"]["course_code"]]}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Constants.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
