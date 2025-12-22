import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ModelConverter {
  static double dynamicToDouble(dynamic number) {
    if (number is String) {
      return double.parse(number);
    } else if (number is int) {
      return number.toDouble();
    } else if (number == null) {
      return 0.00;
    }
    return number ?? 0;
  }

  static bool dynamicToBool(dynamic value) {
    if (value is String) {
      return bool.parse(value);
    } else if (value is num) {
      return value == 1 ? true : false;
    } else if (value is bool) {
      return value;
    }
    return false;
  }

  static num? dynamicToNum(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is String) {
      return null;
    }
    return value;
  }

  static int? dynamicToInt(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is String) {
      return null;
    }
    return value;
  }

  static String? dynamicToString(dynamic value,
      {bool? returnEmptyString = false}) {
    if (value == null) {
      return returnEmptyString == true ? '' : null;
    }
    return value?.toString();
  }

  static String nullableToString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static List<String> toStringList(dynamic value) {
    if (value == null) {
      return [];
    }
    if (value is List) {
      return (value).map((e) => e.toString()).toList();
    }
    return [];
  }

  static DateTime? timeStampToDateTime(Timestamp? value) {
    if (value == null) {
      return null;
    }
    return value.toDate();
  }

  static Map<String, dynamic> stringToMap(String value) {
    final data = json.decode(value);
    return data;
  }
}
