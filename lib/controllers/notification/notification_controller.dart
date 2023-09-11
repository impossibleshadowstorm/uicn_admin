import 'package:get/get.dart';

class NotificationController extends GetxController {
  var selectedToSend = "".obs;
  var selectedYear = 0.obs;

  Map<String, dynamic> notificationCriteria = {
    "PG": [
      {
        "code": "MCA",
        "displayValue": "MCA [General]",
      },
      {
        "code": "MCC",
        "displayValue": "MCC [Cloud and Computing]",
      },
      {
        "code": "MCI",
        "displayValue": "MCI [AI/ML]",
      },
    ],
    "UG": [
      {
        "code": "BCA",
        "displayValue": "BCA [General]",
      },
      {
        "code": "BCV",
        "displayValue": "BCA [AR/VR]",
      },
      {
        "code": "BCU",
        "displayValue": "BCA [UI/UX]",
      },
      {
        "code": "BSC",
        "displayValue": "BSC [General]",
      },
      {
        "code": "IBC",
        "displayValue": "IBC",
      },
    ],
  };

  List<Map<String, dynamic>> notificationCriteriaCourses = [
    {
      "code": "ALL",
      "displayValue": "ALL UG & PG",
    },
    {
      "code": "ALL-PG",
      "displayValue": "ALL PG",
    },
    {
      "code": "MCA",
      "displayValue": "MCA [General]",
    },
    {
      "code": "MCC",
      "displayValue": "MCC [Cloud and Computing]",
    },
    {
      "code": "MCI",
      "displayValue": "MCI [AI/ML]",
    },
    {
      "code": "ALL-UG",
      "displayValue": "ALL UG",
    },
    {
      "code": "BCA",
      "displayValue": "BCA [General]",
    },
    {
      "code": "BCV",
      "displayValue": "BCA [AR/VR]",
    },
    {
      "code": "BCU",
      "displayValue": "BCA [UI/UX]",
    },
    {
      "code": "BSC",
      "displayValue": "BSC [General]",
    },
    {
      "code": "IBC",
      "displayValue": "IBC",
    },
  ];
}
