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
    }
    return false;
  }
}