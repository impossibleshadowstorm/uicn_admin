import 'package:uicn_admin/common/custom_toasts.dart';
import 'package:uicn_admin/controllers/authentication_controller/authentication_controller.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/views/dashboard/main_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import '../../common/form_validation/form_validation.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_input_field.dart';
import '../../controllers/main_application_controller.dart';
import '../../utils/constants.dart';
import 'package:get/get.dart';

class LoginPanel extends StatefulWidget {
  final PanelController panelController;

  const LoginPanel({Key? key, required this.panelController}) : super(key: key);

  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  final MainApplicationController _mainApplicationController = Get.find();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  TextEditingController loginUID = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController signUpName = TextEditingController();
  TextEditingController signUpUID = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();
  TextEditingController signUpConfirmPassword = TextEditingController();
  TextEditingController signUpAboutMe = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7.5.w),
          topRight: Radius.circular(7.5.w),
        ),
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 3.5.h),
          loginTab()
        ],
      ),
    );
  }

  Widget loginTab() {
    return Form(
      key: _formKey,
      child: Obx(() {
        return Column(
          children: [
            CommonInputField.textInputField(
              loginUID,
              "EID",
              FormValidation.emptyValidatorFunction,
              Icons.numbers_sharp,
            ),
            SizedBox(height: 2.5.h),
            CommonInputField.passwordInputField(loginPassword, "Password",
                FormValidation.emptyValidatorFunction),
            SizedBox(height: 2.h),
            SizedBox(
              height: 5.h,
              child: const Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(),
                  // Text(
                  //   "Forgot password ?",
                  //   style: TextStyle(color: Constants.primaryColor),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            _authenticationController.loginLoading.value
                ? CommonButton.primaryFilledProgressButton(null, null)
                : InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _authenticationController
                            .login(
                          eid: loginUID.text.toUpperCase(),
                          password: loginPassword.text,
                        )
                            .then((value) {
                          if (value == 101) {
                            CustomToasts.errorToast(context,
                                "User Doesn't Exists. Please register Yourself.");
                          } else if (value == 1) {
                            CustomToasts.successToast(
                                context, "Login Successful..!");
                            Global.storageServices
                                .setString(Constants.docId, loginUID.text);

                            Get.offAll(() => const MainHomeScreen());
                          } else if (value == 102) {
                            CustomToasts.errorToast(
                                context, "Incorrect Password or Username");
                          } else {
                            CustomToasts.errorToast(context,
                                "Error Signing Up! Please Try again Later..!!");
                          }
                        });
                      }
                    },
                    child:
                        CommonButton.primaryFilledButton(null, null, "Login"),
                  ),
            SizedBox(height: 5.h),
          ],
        );
      }),
    );
  }
}
