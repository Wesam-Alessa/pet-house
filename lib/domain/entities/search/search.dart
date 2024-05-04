import '../../../data/models/foods/pet_foods_model.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/models/tools/pet_tool_model.dart';

class Search{
   List<PetModel> pets;
   List<PetFoodsModel> foods;
   List<PetToolModel> tools;

  Search({required this.pets,required this.foods,required this.tools});
}