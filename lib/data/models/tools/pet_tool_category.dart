import 'package:pet_house/domain/entities/tools/pet_tools_category.dart';

class PetToolCategoryModel extends PetToolsCategory {
  PetToolCategoryModel(
      {required super.label,
      required super.imageUrl,
      required super.id,
      required super.hidden,
      super.picture});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'imageUrl': imageUrl,
      'id': id,
      'hidden': hidden
    };
  }

  factory PetToolCategoryModel.fromMap(Map<String, dynamic> map) {
    return PetToolCategoryModel(
      label: map['label'] as String,
      imageUrl: map['imageUrl'] ?? '',
      id: map['_id'] as String,
      hidden: map['hidden'] ?? false,
    );
  }
}
