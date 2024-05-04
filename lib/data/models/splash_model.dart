import 'dart:convert';

import 'package:pet_house/domain/entities/splash/splash.dart';

class SplashModel extends Splash {
  SplashModel({required super.title, required super.imageUrl, required super.id});
    
    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'imageUrl': imageUrl,
      'id': id,
    };
  }

  factory SplashModel.fromMap(Map<String, dynamic> map) {
    return SplashModel(
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SplashModel.fromJson(String source) => SplashModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
