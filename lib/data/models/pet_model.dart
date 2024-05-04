
import 'dart:convert';


import '../../domain/entities/pet/pet.dart';

class PetModel extends Pet {
  const PetModel(
      {required super.image,
      required super.id,
      required super.name,
      required super.breed,
      required super.quantity,
      required super.ageInYears,
      required super.ageInMonths,
      required super.gender,
      required super.color,
      required super.vaccinations,
      required super.medicalHistory,
      required super.dateOfBirth,
      required super.sterilized,
      required super.seller,
      required super.price,
      required super.description,
      required super.location,
      required super.status,
      required super.category,
      required super.viewCount,
      required super.tags,
      required super.options,
      required super.createdDate,
      required super.updatedDate,
      required super.isFeatured,
      required super.temperature,
      required super.ph,
      required super.specificGravity,
      required super.diet,
      required super.careLevel,
      required super.pictures,
      required super.owner,
      required super.waiting,
      required super.hidden,
      required super.reports});

  Map<String, String> toMap() {
    return <String, String>{
      'image': "$image",
      'id': id,
      'name': name.isEmpty ? 'No name' : name,
      'breed': breed,
      'quantity': quantity.toString(),
      'ageInYears': ageInYears.toString(),
      'ageInMonths': ageInMonths.toString(),
      'gender': gender,
      'color': color.isEmpty ? 'Unspecified color' : color,
      'vaccinations': jsonEncode(vaccinations),
      'medicalHistory': medicalHistory.isEmpty
          ? 'Unspecified medical History '
          : medicalHistory,
      'dateOfBirth': dateOfBirth,
      'sterilized': "$sterilized",
      'seller': jsonEncode(seller.toMap()),
      'price': price.toString(),
      'description':
          description.isEmpty ? 'Unspecified description' : description,
      'location': location.isEmpty ? 'Unspecified location' : location,
      'status': status.isEmpty ? 'Unspecified status' : status,
      'category': category,
      'viewCount': viewCount.toString(),
      'tags': jsonEncode(tags),
      'options': jsonEncode(options),
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'isFeatured': "$isFeatured",
      'temperature':
          temperature.isEmpty ? 'Unspecified temperature' : temperature,
      'ph': ph.isEmpty ? 'Unspecified ph' : ph,
      'specificGravity': specificGravity.isEmpty
          ? 'Unspecified specific gravity '
          : specificGravity,
      'diet': jsonEncode(diet),
      'careLevel': careLevel,
      'pictures': '',
      'waiting': waiting.toString(),
      'hidden': hidden.toString(),
      'reports': jsonEncode(reports),
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
        image: map['image'] == null
            ? []
            : List<PetImage>.from(
                (map['image'] as List<dynamic>).map<PetImage>(
                  (x) => PetImage.fromMap(x as Map<String, dynamic>),
                ),
              ),
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        breed: map['breed'] ?? "",
        quantity: map['quantity'] ?? 0,
        ageInYears: map['ageInYears'] ?? 0,
        ageInMonths: map['ageInMonths'] ?? 0,
        gender: map['gender'] ?? '',
        color: map['color'] ?? '',
        vaccinations: List<Vaccination>.from(
          (map['vaccinations'] as List<dynamic>).map<Vaccination>(
            (x) => Vaccination.fromMap(x as Map<String, dynamic>),
          ),
        ),
        medicalHistory: map['medicalHistory'] ?? '',
        dateOfBirth: map['dateOfBirth'] ?? '',
        sterilized: map['sterilized'] ?? false,
        seller: Seller.fromJson(map['seller']),
        price: map['price'] == null ? 0 : double.parse(map['price'].toString()),
        description: map['description'] ?? '',
        location: map['location'] ?? '',
        status: map['status'] ?? '',
        category: map['category'] ?? '',
        viewCount: map['viewCount'] ?? 0,
        tags: List<String>.from((map['tags'] ?? [])),
        options: List<String>.from((map['options'] ?? '')),
        createdDate: map['createdDate'] ?? '',
        updatedDate: map['updatedDate'] ?? '',
        isFeatured: map['isFeatured'] ?? false,
        temperature: map['temperature'] ?? '',
        ph: map['ph'] ?? '',
        specificGravity: map['specificGravity'] ?? '',
        diet: List<String>.from((map['diet'] ?? [])),
        careLevel: map['careLevel'] ?? '',
        pictures: const [],
        owner: null,
        waiting: map['waiting'],
        hidden: map['hidden'],
        reports: List<Report>.from(
          (map['reports'] as List<dynamic>).map<Report>(
            (x) {
              return Report.fromJson(x);
            },
          ),
        ));
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
