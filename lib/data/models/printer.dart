import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class Printer {
  final String name;
  final String macAddress;
  final PaperSize size;

  const Printer({
    required this.name,
    required this.macAddress,
    required this.size,
  });

  Map<String, dynamic> toJson() =>
      {"name": name, "mac_address": macAddress, "size": size.width};

  Printer.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'],
        macAddress = json['mac_address'],
        size = json['size'] == 384
            ? PaperSize.mm58
            : json['size'] == 512
                ? PaperSize.mm72
                : PaperSize.mm80;
}

class PaperSizeSetting {
  final int width;
  final PaperSize size;

  const PaperSizeSetting({
    required this.width,
    required this.size,
  });
}
