import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uicn_admin/common/widgets/common_button.dart';
import 'package:uicn_admin/common/widgets/common_input_field.dart';
import 'package:uicn_admin/common/widgets/custom_dropdown.dart';
import 'package:uicn_admin/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:get/get.dart';

class CreateFacultyScreen extends StatefulWidget {
  const CreateFacultyScreen({super.key});

  @override
  State<CreateFacultyScreen> createState() => _CreateFacultyScreenState();
}

class _CreateFacultyScreenState extends State<CreateFacultyScreen> {
  final DashboardController _dashboardController = Get.find();

  TextEditingController facultyNameController = TextEditingController();
  TextEditingController facultyPassController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    facultyNameController.dispose();
    facultyPassController.dispose();
    _dashboardController.facultyPosition.value = "";
    _dashboardController.facultyCourse.value = "";
    _dashboardController.facultyYear.value = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightBackgroundColor,
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 100.w,
                child: Row(
                  children: [
                    InkWell(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                  child: Obx(() {
                    return Column(
                      children: [
                        CommonInputField.textInputField(facultyNameController,
                            "Faculty Name", () {}, Icons.person),
                        SizedBox(height: 2.5.w),
                        CommonInputField.textInputField(facultyPassController,
                            "Faculty Password", () {}, Icons.lock),
                        SizedBox(height: 2.5.w),
                        Container(
                          width: 90.w,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                                color: Constants.lightGreyBorderColor),
                          ),
                          child: Center(
                            child: CustomDropdown(
                                items: [
                                  "${DateTime.now().year - 1}",
                                  "${DateTime.now().year}",
                                  "${DateTime.now().year + 1}"
                                ],
                                selectedValue:
                                    _dashboardController.facultyYear.value == ""
                                        ? null
                                        : _dashboardController
                                            .facultyYear.value,
                                hintText: "Year",
                                onChanged: (value) {
                                  _dashboardController.facultyYear.value =
                                      value;
                                }),
                          ),
                        ),
                        SizedBox(height: 2.5.w),
                        Container(
                          width: 90.w,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                                color: Constants.lightGreyBorderColor),
                          ),
                          child: Center(
                            child: CustomDropdown(
                                items: Constants.courseList.values.toList(),
                                selectedValue: _dashboardController
                                            .facultyCourse.value ==
                                        ""
                                    ? null
                                    : _dashboardController.facultyCourse.value,
                                hintText: "Course",
                                onChanged: (value) {
                                  _dashboardController.facultyCourse.value =
                                      value;
                                }),
                          ),
                        ),
                        SizedBox(height: 2.5.w),
                        Container(
                          width: 90.w,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                                color: Constants.lightGreyBorderColor),
                          ),
                          child: Center(
                            child: CustomDropdown(
                                items: const [
                                  Constants.coordinator,
                                  Constants.hod
                                ],
                                selectedValue: _dashboardController
                                            .facultyPosition.value ==
                                        ""
                                    ? null
                                    : _dashboardController
                                        .facultyPosition.value,
                                hintText: "Faculty Role",
                                onChanged: (value) {
                                  _dashboardController.facultyPosition.value =
                                      value;
                                }),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {},
                child: CommonButton.primaryFilledButton(null, null, "Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
