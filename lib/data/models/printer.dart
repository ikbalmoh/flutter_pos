import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class Printer {
  final String name;
  final String macAddress;
  final PaperSize size;
  final bool cut;

  const Printer({
    required this.name,
    required this.macAddress,
    required this.size,
    required this.cut,
  });

  Map<String, dynamic> toJson() =>
      {"name": name, "mac_address": macAddress, "size": size.width, "cut": cut};

  Printer.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        macAddress = json['mac_address'],
        cut = json['cut'] ?? false,
        size = json['size'] == 384
            ? PaperSize.mm58
            : json['size'] == 512
                ? PaperSize.mm72
                : PaperSize.mm80;

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}

class PaperSizeSetting {
  final int width;
  final PaperSize size;

  const PaperSizeSetting({
    required this.width,
    required this.size,
  });
}
