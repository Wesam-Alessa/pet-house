
import '../../../domain/entities/foods/pet_foods_category.dart';

class PetFoodsCategoryModel extends PetFoodsCategory {
  PetFoodsCategoryModel(
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

  factory PetFoodsCategoryModel.fromMap(Map<String, dynamic> map) {
    return PetFoodsCategoryModel(
      label: map['label'] as String,
      imageUrl: map['imageUrl'] ?? '',
      id: map['_id'] as String,
      hidden: map['hidden'] ?? false,
    );
  }
}
