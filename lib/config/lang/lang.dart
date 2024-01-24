import 'package:get/get.dart' show Translations;
import 'en.dart';
import 'id.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'id_ID': id};
}
