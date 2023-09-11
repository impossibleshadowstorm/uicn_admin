import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/common/functions/class%20Functions.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/utils/constants.dart';
import 'package:uicn_admin/views/dashboard/dashboard/dashboard_screen.dart';
import 'package:uicn_admin/views/dashboard/notification/notification_list_screen.dart';
import 'package:uicn_admin/views/dashboard/profile/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainApplicationController extends GetxController {
  var authIdx = 0.obs;
  var bottomNavIdx = 0.obs;
  var securePassword = true.obs;
  String localEid = "";

  var xOffset = 0.0.obs;
  var yOffset = 0.0.obs;

  var isDrawerOpen = false.obs;

  // Dashboard
  List<Widget> bottomNavScreens = [
    const DashboardScreen(),
    const NotificationListScreen(),
  ];

  var filesList = [].obs;
  var selectedDate = DateTime.now().obs;

  Future<String> uploadPdf(String filePath, String fileName, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("$filePath/$fileName.pdf");
    final uploadTask = reference.putFile(file);

    uploadTask.whenComplete(() {});

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }

  Future<List> pickFile() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      allowCompression: true,
      allowMultiple: true,
    );

    if (pickedFiles != null) {
      List filesWithNames = [];
      for (var pickedFile in pickedFiles.files) {
        final fileName = pickedFile.name;
        final File file = File(pickedFile.path!);
        filesWithNames.add({
          "file": file,
          "name": fileName,
        });
      }
      filesList.value = filesWithNames;
      return filesWithNames;
    } else {
      filesList.value = [];
      return [];
    }
  }

  List<String> uploadedFileUrls = [];
  var addNotificationLoading = false.obs;

  Future<int> uploadFilesToFirebase(List filesWithNames) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    addNotificationLoading.value = true;

    int uploadedCount = 0;

    try {
      for (var item in filesWithNames) {
        final Reference ref = storage.ref().child(item["name"]);

        final UploadTask uploadTask = ref.putFile(item["file"]);

        final TaskSnapshot snapshot = await uploadTask;

        if (snapshot.state == TaskState.success) {
          uploadedCount++;
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          uploadedFileUrls.add(downloadUrl);
        } else {
          // Rollback: Delete already uploaded files
          for (var url in uploadedFileUrls) {
            await storage.refFromURL(url).delete();
          }
          addNotificationLoading.value = false;
          return 404;
        }
      }
      addNotificationLoading.value = false;
      return uploadedCount;
    } catch (e) {
      // Rollback: Delete already uploaded files
      print(e.toString());
      for (var url in uploadedFileUrls) {
        await storage.refFromURL(url).delete();
      }
      addNotificationLoading.value = false;
      return 404;
    }
  }

  Future<int> addNotification({
    required String title,
    required String message,
    required List<String> listOfFilesUrl,
    required String links,
    required String sendTo,
    required int year,
  }) async {
    addNotificationLoading.value = true;
    try {
      Map<String, dynamic> data;

      List<String> urlList =
          links.split(RegExp(r'[,\n]')).map((url) => url.trim()).toList();

      if (links.isEmpty) {
        urlList = [];
      }

      DateTime dateTime = DateTime.now();

      if (listOfFilesUrl.isEmpty) {
        data = {
          "docId": Global.storageServices.getString(Constants.docId),
          'title': title,
          'message': message.replaceAll('\n', r'\n'),
          'eid': localEid,
          "links": urlList,
          "timestamp": DateTime.now(),
          "updatedAt": DateTime.now(),
          "sendTo": sendTo,
          "creationDate":
              "${Functions.getPaddedTime(dateTime.day.toString())}-${Functions.getPaddedTime(dateTime.month.toString())}-${Functions.getPaddedTime(dateTime.year.toString())}",
          "creationTime":
              "${Functions.getPaddedTime(dateTime.hour.toString())}:${Functions.getPaddedTime(dateTime.minute.toString())}:${Functions.getPaddedTime(dateTime.second.toString())} ${Functions.getAMorPM("${dateTime.hour}: ${dateTime.minute}")}",
          "validityDate":
              "${Functions.getPaddedTime(selectedDate.value.day.toString())}-${Functions.getPaddedTime(selectedDate.value.month.toString())}-${Functions.getPaddedTime(selectedDate.value.year.toString())}",
          "year": year == 0
              ? Constants.everyone
              : year == 1
                  ? "${DateTime.now().year - 1}"
                  : year == 2
                      ? "${DateTime.now().year}"
                      : "${DateTime.now().year + 1}",
        };
      } else {
        data = {
          "docId": Global.storageServices.getString(Constants.docId),
          'title': title,
          "timestamp": DateTime.now(),
          "updatedAt": DateTime.now(),
          'message': message.replaceAll('\n', r'\n'),
          'eid': localEid,
          "files": listOfFilesUrl,
          "links": urlList,
          "sendTo": sendTo,
          "creationDate":
              "${Functions.getPaddedTime(dateTime.day.toString())}-${Functions.getPaddedTime(dateTime.month.toString())}-${Functions.getPaddedTime(dateTime.year.toString())}",
          "creationTime":
              "${Functions.getPaddedTime(dateTime.hour.toString())}:${Functions.getPaddedTime(dateTime.minute.toString())}:${Functions.getPaddedTime(dateTime.second.toString())} ${Functions.getAMorPM("${dateTime.hour}: ${dateTime.minute}")}",
          "validityDate":
              "${Functions.getPaddedTime(selectedDate.value.day.toString())}-${Functions.getPaddedTime(selectedDate.value.month.toString())}-${Functions.getPaddedTime(selectedDate.value.year.toString())}",
          "year": year == 0
              ? Constants.everyone
              : year == 1
                  ? "${DateTime.now().year - 1}"
                  : year == 2
                      ? "${DateTime.now().year}"
                      : "${DateTime.now().year + 1}",
        };
      }

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc()
          .set(data);
      addNotificationLoading.value = false;
      return 2;
    } catch (e) {
      addNotificationLoading.value = false;
      print('Error adding notification data: $e');
      return 3;
    }
  }

  var finalized = false.obs;

  void getFinalizationData() async {
    finalized.value = await Functions.checkForFinalization();
  }
}
