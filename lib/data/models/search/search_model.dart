import 'package:pet_house/data/models/foods/pet_foods_model.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';

import '../../../domain/entities/search/search.dart';

class SearchModel extends Search {
  SearchModel(
      {required super.pets, required super.foods, required super.tools});

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        pets:
            List<PetModel>.from((json["pets"]as List).map((x) => PetModel.fromMap(x))),
        foods: List<PetFoodsModel>.from(
            (json["foods"]as List).map((x) => PetFoodsModel.fromMap(x))),
        tools: List<PetToolModel>.from(
            (json["tools"]as List).map((x) => PetToolModel.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "pets": List<dynamic>.from(pets.map((x) => x.toJson())),
        "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
      };
}
