import 'package:selleri/data/models/receiving/receiving_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'receiving_form.freezed.dart';
part 'receiving_form.g.dart';

@freezed
class ReceivingForm with _$ReceivingForm {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReceivingForm({
    required String outletId,
    required DateTime receiveDate,
    required int type,
    required String refNumber,
    String? refFrom,
    String? externalReference,
    String? description,
    required List<ReceivingItem> items,
  }) = _ReceivingForm;

  factory ReceivingForm.fromJson(Map<String, dynamic> json) =>
      _$ReceivingFormFromJson(json);

  factory ReceivingForm.initial() => ReceivingForm(
      outletId: '',
      receiveDate: DateTime.now(),
      type: 1,
      refNumber: '',
      items: []);
}
