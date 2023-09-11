import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class StudentListController extends GetxController {
  final TextEditingController searchUidController = TextEditingController();
  var studentList = [].obs;
  var filteredStudentList = [].obs;
  var searching = false.obs;

  filterStudentData(String uid, String section) {
    if (uid.isNotEmpty) {
      searching.value = true;
      filteredStudentList.value = studentList
          .where((student) => student["uid"]
              .toString()
              .toLowerCase()
              .contains(uid.toLowerCase()))
          .toList();
    } else {
      searching.value = false;
      fetchStudentData(section);
    }
  }

  Future<void> fetchStudentData(section) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(Constants.students)
        .where("section", isEqualTo: section)
        .orderBy("uid")
        .get();


    if (querySnapshot.docs.isNotEmpty) {
      studentList.assignAll(querySnapshot.docs);
    }
  }
}
