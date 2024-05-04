import 'package:pet_house/domain/entities/pet/pet_category.dart';

class PetCategoryModel extends PetCategory {
  PetCategoryModel({required super.label, required super.imageUrl, required super.id,required super.hidden, super.picture});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'imageUrl': imageUrl,
      'id': id,
      'hidden':hidden
    };
  }

  factory PetCategoryModel.fromMap(Map<String, dynamic> map) {
    return PetCategoryModel(
      label: map['label'] as String,
      imageUrl: map['imageUrl'] ?? '',
      id: map['_id'] as String,
      hidden: map['hidden'] ?? false,
    );
  }
}
