import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/common/custom_toasts.dart';
import 'package:uicn_admin/common/form_validation/form_validation.dart';
import 'package:uicn_admin/common/widgets/common_input_field.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:uicn_admin/views/dashboard/main_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miladtech_flutter_icons/miladtech_flutter_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateNotificationScreen extends StatefulWidget {
  final String id;

  const UpdateNotificationScreen({
    super.key,
    required this.id,
  });

  @override
  State<UpdateNotificationScreen> createState() =>
      _UpdateNotificationScreenState();
}

class _UpdateNotificationScreenState extends State<UpdateNotificationScreen> {
  final MainApplicationController _mainApplicationController = Get.find();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  Map<String, dynamic>? docData;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _mainApplicationController.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
      // Three months ahead
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Constants.primaryColor, // Set your primary color here
            colorScheme: ColorScheme.light(primary: Constants.primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null &&
        picked != _mainApplicationController.selectedDate.value) {
      _mainApplicationController.selectedDate.value = picked;
      dateController.text =
          "${picked.day.toString()}-${picked.month.toString()}-${picked.year.toString()}";
    }
  }

  @override
  void initState() {
    super.initState();
    () async {
      loadNotificationData();
    }();
  }

  loadNotificationData() async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await firebaseFireStore
        .collection(Constants.notifications)
        .doc(widget.id)
        .get();

    if (snapshot.exists) {
      setState(() {
        docData = snapshot.data() as Map<String, dynamic>?;
      });
      titleController.text = docData!["title"] ?? "";
      descriptionController.text =
          docData!["message"].toString().replaceAll(r"\n", "\n");
      linkController.text = docData!["links"].join(', ');

      String dateString = docData!["validityDate"] ?? "";
      List<String> dateParts = dateString.split('-');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      _mainApplicationController.selectedDate.value =
          DateTime(year, month, day);
      dateController.text = docData!["validityDate"] ?? "";
    }
  }

  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(docData);
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
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      "Update Notification",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border:
                              Border.all(color: Constants.lightGreyBorderColor),
                        ),
                        child: TextFormField(
                          cursorColor: Constants.primaryColor,
                          controller: dateController,
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Constants.primaryColor),
                            labelText: "Validity Date",
                            border: InputBorder.none,
                            icon: Icon(
                              AntDesign.calendar,
                              size: 28,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      CommonInputField.textInputField(
                        titleController,
                        "Title",
                        FormValidation.emptyValidatorFunction,
                        MaterialIcons.apps,
                      ),
                      SizedBox(height: 2.5.h),
                      Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Constants.lightGreyBorderColor),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w, vertical: 2.5.w),
                        child: TextFormField(
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          controller: descriptionController,
                          cursorColor: Constants.primaryColor,
                          validator: FormValidation.emptyValidatorFunction,
                          maxLines: null,
                          minLines: 10,
                          onChanged: (text) {},
                          decoration: const InputDecoration(
                            hintText: 'Message',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.black,
                              margin: EdgeInsets.only(right: 2.5.w),
                            ),
                          ),
                          Text(
                            "Attach Files",
                            style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.black,
                              margin: EdgeInsets.only(left: 2.5.w),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: .5.h),
                      Obx(() {
                        return SizedBox(
                          width: 100.w,
                          height: 150,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _mainApplicationController
                                      .filesList.isNotEmpty
                                  ? _mainApplicationController.filesList.length
                                  : 1,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    _mainApplicationController
                                            .filesList.isNotEmpty
                                        ? fileTile(
                                            _mainApplicationController
                                                .filesList[index],
                                            index)
                                        : const SizedBox(),
                                    SizedBox(width: 2.5.w),
                                    _mainApplicationController
                                                        .filesList.length -
                                                    1 ==
                                                index ||
                                            _mainApplicationController
                                                .filesList.isEmpty
                                        ? InkWell(
                                            onTap: () {
                                              _mainApplicationController
                                                  .pickFile();
                                            },
                                            child: Container(
                                              height: 120,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1.5.w),
                                                border: Border.all(
                                                    color: Constants
                                                        .lightGreyTextColor),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Text(
                                                    "Add",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                );
                              }),
                        );
                      }),
                      SizedBox(height: 2.5.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.black,
                              margin: EdgeInsets.only(right: 2.5.w),
                            ),
                          ),
                          Text(
                            "Attach Links",
                            style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.black,
                              margin: EdgeInsets.only(left: 2.5.w),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Constants.lightGreyBorderColor),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w, vertical: 2.5.w),
                        child: TextFormField(
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          controller: linkController,
                          cursorColor: Constants.primaryColor,
                          maxLines: null,
                          minLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Comma Separated Links',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          if (dateController.text.isEmpty) {
            CustomToasts.errorToast(context, "Please check for a valid date");
          } else if (_formKey.currentState!.validate()) {
            FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
            try {
              Map<String, dynamic> oldData;
              DocumentSnapshot snapshot = await firebaseFireStore
                  .collection(Constants.notifications)
                  .doc(widget.id)
                  .get();
              oldData = snapshot.data() as Map<String, dynamic>;

              Map<String, dynamic> newData = {};

              newData.addAll(oldData);
              newData['validityDate'] = dateController.text;
              newData['title'] = titleController.text;
              newData['message'] = descriptionController.text;
              newData["updatedAt"] = DateTime.now();
              List<String> urlList = linkController.text.isEmpty
                  ? []
                  : linkController.text
                      .split(RegExp(r'[,\n]'))
                      .map((url) => url.trim())
                      .toList();

              newData['links'] = urlList;

              await firebaseFireStore
                  .collection(Constants.notifications)
                  .doc(widget.id)
                  .update(newData)
                  .then((value) {
                CustomToasts.successToast(
                    context, "Data updated successfully..");
                Get.to(() => const MainHomeScreen());
              });
            } catch (error) {
              if (mounted) {
                CustomToasts.successToast(context, "Unable to add data..");
              }
            }
          }
        },
        child: Container(
          width: 40.w,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
          decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(1.5.w)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Update",
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 2.5.w),
              Icon(
                Icons.send,
                color: Colors.white,
                size: 18.sp,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fileTile(var fileType, int index) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.5.w),
        border: Border.all(color: Constants.lightGreyTextColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          fileType["name"].toString().split('.').last == "pdf"
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "PDF",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Image",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
          Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: () {
                _mainApplicationController.filesList.removeAt(index);
              },
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.lightGreyBorderColor,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    linkController.dispose();
    descriptionController.dispose();
    dateController.dispose();
  }
}
