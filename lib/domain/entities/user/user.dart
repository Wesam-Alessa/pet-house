// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import '../../../data/models/user_model.dart';

class User {
  final String name;
  final String id;
  final String email;
  final String phone;
  final String picture;
  final String address;
  List<dynamic> favourites;
  List<dynamic> myPets;
  List<dynamic> myFoods;
  List<dynamic> myTools;
  final bool isAdmin;
  final bool isManager;
  List<dynamic> reports;
  final bool disabled;
  final UserModel? disabledBy;
  final String whyDisabled;
  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.picture,
      required this.phone,
      required this.favourites,
      required this.address,
      required this.myPets,required this.myFoods,required this.myTools,
      required this.isAdmin,
      required this.isManager,
      required this.reports,
      required this.disabled,
      required this.disabledBy,
      required this.whyDisabled,
      });
}
