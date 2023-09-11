import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:uicn_admin/controllers/main_application_controller.dart';
import '../../utils/constants.dart';

class CommonInputField {
  static Widget textInputField(TextEditingController controller,
      String labelText, Function validator, IconData iconData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Constants.lightGreyBorderColor),
      ),
      child: TextFormField(
        cursorColor: Constants.primaryColor,
        validator: (value) => validator(value),
        controller: controller,
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Constants.primaryColor,
            fontSize: 14.sp,
          ),
          labelText: labelText,
          border: InputBorder.none,
          icon: Icon(
            iconData,
            size: 28,
            color: Constants.primaryColor,
          ),
        ),
      ),
    );
  }

  static Widget passwordInputField(
      TextEditingController controller, String labelText, Function validator) {
    MainApplicationController _mainApplicationController = Get.find();

    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Constants.lightGreyBorderColor),
        ),
        child: TextFormField(
            controller: controller,
            validator: (value) => validator(value),
            obscureText: _mainApplicationController.securePassword.value,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: Constants.primaryColor,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: Constants.primaryColor,
                fontSize: 14.sp,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  _mainApplicationController.securePassword.value =
                      !_mainApplicationController.securePassword.value;
                },
                child: Icon(
                  _mainApplicationController.securePassword.value
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  size: 28,
                  color: Constants.primaryColor,
                ),
              ),
              border: InputBorder.none,
              icon: Icon(
                Icons.lock,
                size: 28,
                color: Constants.primaryColor,
              ), //icon at head of input
            )),
      );
    });
  }
}
