import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_image.freezed.dart';
part 'transaction_image.g.dart';

@freezed
class TransactionImage with _$TransactionImage {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TransactionImage({
    int? id,
    String? transactionNo,
    @JsonKey(name: 'image_path') required String imagePath,
    @JsonKey(name: 'image_notes') String? imageNotes,
  }) = _TransactionImage;

  factory TransactionImage.fromJson(Map<String, dynamic> json) =>
      _$TransactionImageFromJson(json);
}
