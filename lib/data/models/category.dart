import 'package:objectbox/objectbox.dart';

@Entity(uid: 5401018273546124526)
class Category {
  int id;

  @Index()
  String idCategory;

  String categoryName;
  bool isActive;
  String? code;

  Category(
      {required this.id,
      required this.idCategory,
      required this.code,
      required this.categoryName,
      required this.isActive});

  Category.fromJson(Map<dynamic, dynamic> json)
      : id = 0,
        idCategory = json['id_category'],
        code = json['code'],
        categoryName = json['category_name'],
        isActive = json['is_active'] == 1 ? true : false;

  Map<String, dynamic> toJson() => {
        'id_category': idCategory,
        'code': code,
        'category_name': categoryName,
        'is_active': isActive,
      };
}
