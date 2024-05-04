import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/foods/pet_food_category.dart';

abstract class BasePetFoodsCategoriesRepository {
  Future<Either<Failure, List<PetFoodsCategoryModel>>> getPetFoodsCategories();
  Future<Either<Failure, List<PetFoodsCategoryModel>>> addNewPetFoodsCategory(PetFoodsCategoryModel parameters);
  Future<Either<Failure, PetFoodsCategoryModel>> updatePetFoodsCategory(PetFoodsCategoryModel parameters);
}