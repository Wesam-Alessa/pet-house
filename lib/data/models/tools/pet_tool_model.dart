
import 'dart:convert';

import '../../../domain/entities/tools/pet_tools.dart';

class PetToolModel extends PetTool {
  const PetToolModel(
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
        required super.reports,

        required super.pictures,
        required super.createdDate,
        required super.updatedDate,
        required super.isFeatured,
      });

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

  factory PetToolModel.fromMap(Map<String, dynamic> map) {
    return PetToolModel(

        image: map['image'] == null
            ? []
            : List<PetToolImage>.from(
          (map['image'] as List<dynamic>).map<PetToolImage>(
                (x) => PetToolImage.fromMap(x as Map<String, dynamic>),
          ),
        ),
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        quantity: map['quantity'] ?? 0,
        color: map['color'] ?? '',
        seller: ToolSeller.fromJson(map['seller']),
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

  factory PetToolModel.fromJson(String source) =>
      PetToolModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
