import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:get/get.dart';
import '../main_application_controller.dart';

class AuthenticationController extends GetxController {
  MainApplicationController mainApplicationController = Get.find();

  var completionYear = "".obs;
  var loginLoading = false.obs;

  Future<int> login({required String eid, required String password}) async {
    loginLoading.value = true;
    try {
      final userDocument = await FirebaseFirestore.instance
          .collection(Constants.admin)
          .doc(eid)
          .get();

      // If the document doesn't exist, the user is not registered
      if (!userDocument.exists) {
        loginLoading.value = false;
        return 101;
      }

      // Get the stored hashed password and salt from the document
      String storedHashedPassword = userDocument['password'];

      Global.storageServices
          .setString(Constants.courseCode, userDocument['role']['course_code']);
      Global.storageServices
          .setString(Constants.position, userDocument['role']['position']);
      mainApplicationController.localEid = userDocument["eid"];

      loginLoading.value = false;
      return BCrypt.checkpw(password, storedHashedPassword) ? 1 : 102;
    } catch (e) {
      loginLoading.value = false;
      print('Error logging in: $e');
      return 0;
    }
  }
}
