import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'promotion_list_provider.g.dart';

@Riverpod(keepAlive: true)
class PromotionList extends _$PromotionList {
  @override
  Stream<List<Promotion>> build(
      {String? search, int? type, PickerDateRange? range}) {
    return objectBox.promotionsStream(
      search: search,
      type: type,
      range: range,
    );
  }
}
