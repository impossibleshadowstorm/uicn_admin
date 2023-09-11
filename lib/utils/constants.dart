import 'dart:ui';

class Constants {
  //----------------------------------------------------------------
  // Color Constants
  //----------------------------------------------------------------
  // static Color primaryColor = const Color(0xff6F947D);
  static Color primaryColor = const Color(0xff111B31);
  static Color primaryDarkBlueColor = const Color(0xff111B31);
  static Color lightGreyBorderColor = const Color(0xffEEF0F2);
  static Color darkGreyTextColor = const Color(0xffB4B5C3);
  static Color midGreyTextColor = const Color(0xffB4B5C3);
  static Color lightGreyTextColor = const Color(0xFF707E94);
  static Color darkBlackTextColor = const Color(0xFF060606);
  static Color lightBackgroundColor = const Color(0xFFF9F9F9);

  //----------------------------------------------------------------
  // Lists Constants
  //----------------------------------------------------------------

  static Map<String, String> courseList = {
    "BC201": "BCA [General] - BC201",
    "BC204": "BCA [AR/VR] - BC204",
    "BC205": "BCA [UI/UX] - BC205",
    "BC203": "BSC [CS] - BC203",
    "MC305": "MCA [General] - MC305",
    "MC306": "MCA [AI/ML] - MC306",
    "MC307": "MCA [CC] - MC307",
  };

  static Map<String, String> courseCodeMap = {
    "BC201": "BCA",
    "BC204": "BCV",
    "BC205": "BCU",
    "BC203": "BSC",
    "MC305": "MCA",
    "MC306": "MCI",
    "MC307": "MCC",
  };

  //----------------------------------------------------------------
  // Notifications Key Constants
  //----------------------------------------------------------------

  static const String everyone = "ALL";
  static const String allUG = "ALL-UG";
  static const String allPG = "ALL-PG";
  static const String mcaGeneral = "MCA";
  static const String mcaCloud = "MCC";
  static const String mcaAI = "MCI";
  static const String bcaGeneral = "BCA";
  static const String bcaAR = "BCV";
  static const String bcaUI = "BCU";
  static const String bsc = "BSC";
  static const String hod = "Head Of Department";
  static const String coordinator = "Academic Coordinator";
  static const String ad = "Additional Director";

  //----------------------------------------------------------------
  // Preferences Key Constants
  //----------------------------------------------------------------

  static const String eid = "eid";
  static const String docId = "doc_id";
  static const String courseCode = "course_code";
  static const String finalized = "finalized";
  static const String position = "position";
  static const String enrolledYear = "enrolled_year";

  //----------------------------------------------------------------
  // Collection Names Constants
  //----------------------------------------------------------------

  static const String students = "students";
  static const String admin = "admin";
  static const String notifications = "notifications";
  static const String externalData = "external_data";

  //----------------------------------------------------------------
  // Document Names Constants
  //----------------------------------------------------------------

  static const String finalization = "finalization";
}
