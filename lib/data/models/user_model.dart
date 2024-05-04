// ignore_for_file: constant_identifier_names

import 'package:pet_house/domain/entities/user/user.dart';
import 'package:dartz/dartz.dart';

class UserModel extends User {
  static const String NAME = 'name';
  static const String ID = '_id';
  static const String EMAIL = 'email';
  static const String PHONE = 'phone';
  static const String FAVOURITES = 'favourites';
  static const String PICTURE = 'picture';
  static const String ADDRESS = 'address';
  static const String MYPETS = "myPets";
  static const String MYTOOLS = "myPetTools";
  static const String MYFOODS = "myPetFoods";
  static const String ISADMIN = 'isAdmin';
  static const String ISMANAGER = 'isManager';
  static const String REPORTS = 'reports';
  static const String DISABLED = 'disabled';
  static const String DISABLEDBY = 'disabledBy';
  static const String WHYDISABLED = 'whyDisabled';

  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.picture,
    required super.phone,
    required super.favourites,
    required super.address,
    required super.myPets,
    required super.myFoods,
    required super.myTools,
    required super.isAdmin,
    required super.isManager,
    required super.reports,
    required super.disabled,
    required super.disabledBy,
    required super.whyDisabled,
  });

  factory UserModel.fromjson(Map<String, dynamic> json) => UserModel(
        name: json[NAME] ?? '',
        id: json[ID] ?? "",
        email: json[EMAIL] ?? '',
        phone: json[PHONE].toString(),
        picture: json[PICTURE] ?? '',
        address: json[ADDRESS] ?? '',
        favourites: json[FAVOURITES] ?? [],
        myPets: json[MYPETS] ?? [],
        myFoods: json[MYFOODS] ?? [],
        myTools: json[MYTOOLS] ?? [],
        isAdmin: json[ISADMIN] ?? false,
        isManager: json[ISMANAGER] ?? false,
        reports: json[REPORTS] ?? [],
        disabled: json[DISABLED] ?? false,
        disabledBy: json[DISABLEDBY] == null
            ? null
            : UserModel.fromjson(json[DISABLEDBY]),
        whyDisabled: json[WHYDISABLED] ?? '',
        //  List<ProductModel>.from(
        //     json[MYPRODUCTS].map((e) => ProductModel.fromMap(e, json[ID]))),
        // List<ProductModel>.from(
        //     json[FAVOURITES].map((e) => ProductModel.fromMap(e,json[ID]))),
      );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "email": email,
      "phone": phone,
      "picture": picture,
      "address": address,
      "favourites": favourites,
      "myPets": myPets,
      "myPetFoods": myFoods,
      "myPetTools": myTools,
      'isAdmin': isAdmin,
      'isManager': isManager,
      'reports': reports,
      'disabled': disabled,
    };
  }
}
