
import 'dart:convert';

import '../../../domain/entities/foods/pet_foods.dart';

class PetFoodsModel extends PetFoods {
  const PetFoodsModel(
      {required super.image,
        required super.id,
        required super.name,
        required super.quantity,
        required super.color,
        required super.seller,
        required super.price,
        required super.description,
        required super.location,
        required super.status,
        required super.category,
        required super.viewCount,
        required super.waiting,
        required super.hidden,
        required super.pictures,

        required super.createdDate,
        required super.updatedDate,
        required super.isFeatured,
        required super.reports});

  Map<String, String> toMap() {
    return <String, String>{
      'image': "$image",
      'id': id,
      'name': name.isEmpty ? 'No name' : name,
      'quantity': quantity.toString(),
      'color': color.isEmpty ? 'Unspecified color' : color,
      'seller': jsonEncode(seller.toMap()),
      'price': price.toString(),
      'description':
      description.isEmpty ? 'Unspecified description' : description,
      'location': location.isEmpty ? 'Unspecified location' : location,
      'status': status.isEmpty ? 'Unspecified status' : status,
      'category': category,
      'viewCount': viewCount.toString(),
      'pictures': '',
      'waiting': waiting.toString(),
      'hidden': hidden.toString(),
      'reports': jsonEncode(reports),

      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'isFeatured': "$isFeatured",
    };
  }

  factory PetFoodsModel.fromMap(Map<String, dynamic> map) {
    return PetFoodsModel(
        image: map['image'] == null
            ? []
            : List<PetFoodsImage>.from(
          (map['image'] as List<dynamic>).map<PetFoodsImage>(
                (x) => PetFoodsImage.fromMap(x as Map<String, dynamic>),
          ),
        ),
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        quantity: map['quantity'] ?? 0,
        color: map['color'] ?? '',
        seller: FoodsSeller.fromJson(map['seller']),
        price: map['price'] == null ? 0 : double.parse(map['price'].toString()),
        description: map['description'] ?? '',
        location: map['location'] ?? '',
        status: map['status'] ?? '',
        category: map['category'] ?? '',
        viewCount: map['viewCount'] ?? 0,
        waiting: map['waiting'],
        hidden: map['hidden'],
        createdDate: map['createdDate'] ?? '',
        updatedDate: map['updatedDate'] ?? '',
        isFeatured: map['isFeatured'] ?? false,
        pictures: const [],
        reports: List<Report>.from(
          (map['reports'] as List<dynamic>).map<Report>(
                (x) {
              return Report.fromJson(x);
            },
          ),
        ));
  }

  String toJson() => json.encode(toMap());

  factory PetFoodsModel.fromJson(String source) =>
      PetFoodsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
