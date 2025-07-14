import 'package:easy_localization/easy_localization.dart';
import 'package:selleri/shared/model/option.dart';

Map<int, String> assignsType = {
  1: 'all_customer'.tr(),
  2: 'member'.tr(),
  3: 'non_member'.tr(),
  4: 'group'.tr()
};

List<Option> cardIdOptions = [
  Option(id: 1, text: 'KTP'),
  Option(id: 2, text: 'SIM'),
  Option(id: 3, text: 'student_card'.tr()),
  Option(id: 4, text: 'NIP')
];
