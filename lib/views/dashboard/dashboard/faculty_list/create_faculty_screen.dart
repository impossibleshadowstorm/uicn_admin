import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uicn_admin/common/widgets/common_input_field.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:get/get.dart';

class CreateFacultyScreen extends StatefulWidget {
  const CreateFacultyScreen({super.key});

  @override
  State<CreateFacultyScreen> createState() => _CreateFacultyScreenState();
}

class _CreateFacultyScreenState extends State<CreateFacultyScreen> {
  TextEditingController facultyNameController = TextEditingController();
  TextEditingController facultyPassController = TextEditingController();

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
                      "Create Faculty Credential",
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
                child: Column(
                  children: [
                    CommonInputField.textInputField(facultyNameController,
                        "Faculty Name", () {}, Icons.person),
                    CommonInputField.textInputField(facultyPassController,
                        "Faculty Password", () {}, Icons.lock),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
