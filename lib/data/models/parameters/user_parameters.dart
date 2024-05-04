import 'dart:io';

import 'package:equatable/equatable.dart';

class UserParameters extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String address;
  final File? picture;
  final bool isAdmin;
  
  const UserParameters({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    this.picture,
    required this.isAdmin,
  });
  @override
  List<Object> get props => [name, email, password, phone, address, isAdmin];
}
