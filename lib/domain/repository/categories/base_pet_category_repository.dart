import 'package:pet_house/data/models/pet_category_model.dart';
 import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';

abstract class BasePetCategoriesRepository {
  Future<Either<Failure, List<PetCategoryModel>>> getPetCategories();
  Future<Either<Failure, List<PetCategoryModel>>> addPetCategories(PetCategoryModel parameters);
  Future<Either<Failure, PetCategoryModel>> updatePetCategory(PetCategoryModel parameters);
}