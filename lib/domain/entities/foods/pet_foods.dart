import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'dart:io';

class PetFoods extends Equatable {
  final List<PetFoodsImage> image;
  final List<File> pictures;
  final String id;
  final String name;
  final int quantity;
  final String color;
  final double price;
  final String description;
  final String location;
  final String status;
  final String category;
  final int viewCount;
  final bool waiting;
  final bool hidden;
  final List<Report> reports;
  final FoodsSeller seller;
  final String createdDate;
  final String updatedDate;
  final bool isFeatured;
  const PetFoods({
    required this.image,
    required this.id,
    required this.name,
    required this.quantity,
    required this.color,
    required this.price,
    required this.description,
    required this.location,
    required this.status,
    required this.category,
    required this.viewCount,
    required this.waiting,
    required this.hidden,
    required this.reports,
    required this.seller,required this.pictures,required this.createdDate,
    required this.updatedDate,
    required this.isFeatured,
  });

  @override
  List<Object?> get props => [
    image,
    id,
    name,
    quantity,
    color,
    price,
    description,
    location,
    status,
    category,
    viewCount,
    waiting,
    hidden,
    reports,createdDate,
    updatedDate,isFeatured,
    seller,pictures
  ];
}

class FoodsSeller extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String picture;
  final String address;

  const FoodsSeller({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.picture,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phone, picture, address];

  FoodsSeller copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? picture,
    String? address,
  }) {
    return FoodsSeller(
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

  factory FoodsSeller.fromJson(Map<String, dynamic> json) {
    return FoodsSeller(
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

class PetFoodsImage extends Equatable {
  final String webViewLink;
  final String webContentLink;

  const PetFoodsImage({
    required this.webViewLink,
    required this.webContentLink,
  });

  @override
  List<Object?> get props => [webViewLink, webContentLink];

  PetFoodsImage copyWith({
    String? webViewLink,
    String? webContentLink,
  }) {
    return PetFoodsImage(
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

  factory PetFoodsImage.fromMap(Map<String, dynamic> map) {
    return PetFoodsImage(
      webViewLink: map['webViewLink'] as String,
      webContentLink: map['webContentLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetFoodsImage.fromJson(String source) =>
      PetFoodsImage.fromMap(json.decode(source) as Map<String, dynamic>);
}
