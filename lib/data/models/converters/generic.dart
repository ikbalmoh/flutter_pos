import 'dart:convert';

class Converters {
  static double dynamicToDouble(dynamic number) {
    if (number is String) {
      return double.parse(number);
    } else if (number is int) {
      return number.toDouble();
    } else if (number == null) {
      return 0.00;
    }
    return number;
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

  static Map<String, dynamic> stringToMap(String value) {
    final data = json.decode(value);
    return data;
  }
}
