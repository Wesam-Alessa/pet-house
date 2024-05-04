// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

class ItemOwner extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String picture;
  final String address;

  const ItemOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.picture,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phone, picture, address];

  ItemOwner copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? picture,
    String? address,
  }) {
    return ItemOwner(
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

  factory ItemOwner.fromMap(Map<String, dynamic> map) {
    return ItemOwner(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      picture: map['picture'] ?? '',
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemOwner.fromJson(String source) =>
      ItemOwner.fromMap(json.decode(source) as Map<String, dynamic>);
}
