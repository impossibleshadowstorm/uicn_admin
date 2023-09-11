import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uicn_admin/services/global.dart';
import 'package:uicn_admin/utils/constants.dart';

class Functions {
  static String getCodeFromCourse(String courseString) {
    int hyphenIndex = courseString.indexOf('-');
    if (hyphenIndex != -1 && hyphenIndex + 1 < courseString.length) {
      return courseString.substring(hyphenIndex + 1).trim();
    }
    return '';
  }

  // Check if sectioning is finalized
  static Future<bool> checkForFinalization() async {
    final String docId = Global.storageServices.getString(Constants.docId)!;
    final int year = 2000 + int.parse(docId.toLowerCase().substring(0, 2));
    try {
      final finalizationData = await FirebaseFirestore.instance
          .collection(Constants.externalData)
          .doc(Constants.finalization)
          .get();

      return finalizationData[year.toString()][docId.substring(2).toLowerCase()];
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }

  static String getAMorPM(String time){
    return int.parse(time.split(':').first) > 12 ? "PM" : "AM";
  }

  static String getPaddedTime(String data){
    return data.padLeft(2, '0');
  }
}
