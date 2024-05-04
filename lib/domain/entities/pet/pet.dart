// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:pet_house/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final List<PetImage> image;
  final String id;
  final String name;
  final String breed;
  final int quantity;
  final int ageInYears;
  final int ageInMonths;
  final String gender;
  final String color;
  final List<Vaccination> vaccinations;
  final String medicalHistory;
  final String dateOfBirth;
  final bool sterilized;
  final Seller seller;
  final double price;
  final String description;
  final String location;
  final String status;
  final String category;
  final int viewCount;
  final List<String> tags;
  final List<String> options;
  final String createdDate;
  final String updatedDate;
  final bool isFeatured;
  final String temperature;
  final String ph;
  final String specificGravity;
  final List<String> diet;
  final String careLevel;
  final List<File> pictures;
  final UserModel? owner;
  final bool waiting;
  final bool hidden;
  final List<Report> reports;

  const Pet({
    required this.image,
    required this.id,
    required this.name,
    required this.breed,
    required this.quantity,
    required this.ageInYears,
    required this.ageInMonths,
    required this.gender,
    required this.color,
    required this.vaccinations,
    required this.medicalHistory,
    required this.dateOfBirth,
    required this.sterilized,
    required this.seller,
    required this.price,
    required this.description,
    required this.location,
    required this.status,
    required this.category,
    required this.viewCount,
    required this.tags,
    required this.options,
    required this.createdDate,
    required this.updatedDate,
    required this.isFeatured,
    required this.temperature,
    required this.ph,
    required this.specificGravity,
    required this.diet,
    required this.careLevel,
    required this.pictures,
    required this.owner,
    required this.waiting,
    required this.hidden,
    required this.reports,
  });
  Pet copyWith({
    List<PetImage>? image,
    String? id,
    String? name,
    String? breed,
    int? quantity,
    int? ageInYears,
    int? ageInMonths,
    String? gender,
    String? color,
    List<Vaccination>? vaccinations,
    String? medicalHistory,
    String? dateOfBirth,
    bool? sterilized,
    Seller? seller,
    double? price,
    String? description,
    String? location,
    String? status,
    String? category,
    int? viewCount,
    List<String>? tags,
    List<String>? options,
    String? createdDate,
    String? updatedDate,
    bool? isFeatured,
    String? temperature,
    String? ph,
    String? specificGravity,
    List<String>? diet,
    String? careLevel,
    List<File>? pictures,
    UserModel? owner,
    bool? waiting,
    bool? hidden,
    List<Report>? reports,
  }) {
    return Pet(
      image: image ?? this.image,
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      quantity: quantity ?? this.quantity,
      ageInYears: ageInYears ?? this.ageInYears,
      ageInMonths: ageInMonths ?? this.ageInMonths,
      gender: gender ?? this.gender,
      color: color ?? this.color,
      vaccinations: vaccinations ?? List.from(this.vaccinations),
      medicalHistory: medicalHistory ?? this.medicalHistory,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sterilized: sterilized ?? this.sterilized,
      seller: seller ?? this.seller,
      price: price ?? this.price,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      category: category ?? this.category,
      viewCount: viewCount ?? this.viewCount,
      tags: tags ?? List.from(this.tags),
      options: options ?? List.from(this.options),
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      isFeatured: isFeatured ?? this.isFeatured,
      temperature: temperature ?? this.temperature,
      ph: ph ?? this.ph,
      specificGravity: specificGravity ?? this.specificGravity,
      diet: diet ?? List.from(this.diet),
      careLevel: careLevel ?? this.careLevel,
      pictures: pictures ?? this.pictures,
      owner: owner ?? this.owner,
      waiting: waiting ?? this.waiting,
      hidden: hidden ?? this.hidden,
      reports: reports ?? List.from(this.reports),
    );
  }

  @override
  List<Object?> get props => [
        image,
        id,
        name,
        breed,
        ageInYears,
        ageInMonths,
        gender,
        color,
        vaccinations,
        medicalHistory,
        dateOfBirth,
        sterilized,
        seller,
        price,
        description,
        location,
        status,
        category,
        viewCount,
        tags,
        options,
        createdDate,
        updatedDate,
        isFeatured,
        temperature,
        ph,
        specificGravity,
        diet,
        careLevel,
        pictures,
        owner,
        waiting,
        hidden,
        reports
      ];
}

class Report extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String picture;
  final String address;

  const Report({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.picture,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phone, picture, address];

  Report copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? picture,
    String? address,
  }) {
    return Report(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        picture: picture ?? this.picture,
        address: address ?? this.address);
  }

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'picture': picture,
      'address': address,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      picture: json['picture'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['picture'] = picture;
    data['address'] = address;
    return data;
  }
}

class PetImage extends Equatable {
  final String webViewLink;
  final String webContentLink;

  const PetImage({
    required this.webViewLink,
    required this.webContentLink,
  });

  @override
  List<Object?> get props => [webViewLink, webContentLink];

  PetImage copyWith({
    String? webViewLink,
    String? webContentLink,
  }) {
    return PetImage(
      webViewLink: webViewLink ?? this.webViewLink,
      webContentLink: webContentLink ?? this.webContentLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'webViewLink': webViewLink,
      'webContentLink': webContentLink,
    };
  }

  factory PetImage.fromMap(Map<String, dynamic> map) {
    return PetImage(
      webViewLink: map['webViewLink'] as String,
      webContentLink: map['webContentLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetImage.fromJson(String source) =>
      PetImage.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Vaccination extends Equatable {
  final String name;
  final String expirationDate;
  final String id;

  const Vaccination({
    required this.name,
    required this.expirationDate,
    required this.id,
  });

  @override
  List<Object?> get props => [name, expirationDate, id];

  Vaccination copyWith({
    String? name,
    String? expirationDate,
    String? id,
  }) {
    return Vaccination(
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'expirationDate': expirationDate,
      'id': id,
    };
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      name: map['name'] as String,
      expirationDate: map['expirationDate'] as String,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vaccination.fromJson(String source) =>
      Vaccination.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Seller extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String picture;
  final String address;

  const Seller({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.picture,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phone, picture, address];

  Seller copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? picture,
    String? address,
  }) {
    return Seller(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        picture: picture ?? this.picture,
        address: address ?? this.address);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'picture': picture,
      'address': address,
    };
  }

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      picture: json['picture'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['picture'] = picture;
    data['address'] = address;
    return data;
  }
}
