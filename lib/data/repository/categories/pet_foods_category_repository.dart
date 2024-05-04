import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repository/categories/base_pet_foods_category_repository.dart';
 import '../../datasource/categories/foods_categories_remote_data_source.dart';
import '../../models/foods/pet_food_category.dart';

class PetFoodsCategoriesRepository extends BasePetFoodsCategoriesRepository {
  final BasePetFoodsCategoriesRemoteDataSource basePetFoodsCategoriesRemoteDataSource;

  PetFoodsCategoriesRepository(this.basePetFoodsCategoriesRemoteDataSource);

  @override
  Future<Either<Failure,List<PetFoodsCategoryModel>>> getPetFoodsCategories()async {
    final result = await basePetFoodsCategoriesRemoteDataSource.getPetFoodsCategories();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetFoodsCategoryModel>>> addNewPetFoodsCategory(PetFoodsCategoryModel parameters)async {
    final result = await basePetFoodsCategoriesRemoteDataSource.addNewPetFoodsCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, PetFoodsCategoryModel>> updatePetFoodsCategory(PetFoodsCategoryModel parameters)async {
    final result = await basePetFoodsCategoriesRemoteDataSource.updatePetFoodsCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }


}