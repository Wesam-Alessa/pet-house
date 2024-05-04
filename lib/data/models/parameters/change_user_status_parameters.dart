// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

 
class ChangeUserStatusByManagerParameters {
  final String uid;
  final String whyDisabled;
  final bool isAdmin;
  final bool isManager;
  final bool disabled;

  ChangeUserStatusByManagerParameters(
      {required this.uid,
      required this.isAdmin,
      required this.whyDisabled,
      required this.isManager,
      required this.disabled});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'isAdmin': isAdmin.toString(),
      'isManager': isManager.toString(),
      'disabled': disabled.toString(),
      'whyDisabled':whyDisabled
    };
  }
  String toJson() => json.encode(toMap());

 }
