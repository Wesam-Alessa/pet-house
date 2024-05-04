import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';
import 'package:pet_house/domain/entities/favourites/favourites.dart';

import '../foods/pet_foods_model.dart';

class FavouritesModel extends Favourites {
  FavouritesModel({required super.type, required super.value});

  factory FavouritesModel.fromjson(Map<String, dynamic> json) =>
      FavouritesModel(
          type: json['type'],
          value: json['type'] == 'pet'
              ? PetModel.fromMap(json['value'])
              : json['type'] == 'tool'
                  ? PetToolModel.fromMap(json['value'])
                  : PetFoodsModel.fromMap(json['value']));
}
