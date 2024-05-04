import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/datasource/categories/pet_categories_remote_data_source.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:pet_house/domain/repository/categories/base_pet_category_repository.dart';
import 'package:dartz/dartz.dart';

class PetCategoriesRepository extends BasePetCategoriesRepository {
  final BasePetCategoriesRemoteDataSource basePetCategoriesRemoteDataSource;

  PetCategoriesRepository(this.basePetCategoriesRemoteDataSource);

  @override
  Future<Either<Failure,List<PetCategoryModel>>> getPetCategories()async {
        final result = await basePetCategoriesRemoteDataSource.getPetCategories();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  
  @override
  Future<Either<Failure, List<PetCategoryModel>>> addPetCategories(PetCategoryModel parameters)async {
        final result = await basePetCategoriesRemoteDataSource.addNewPetCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  
  @override
  Future<Either<Failure, PetCategoryModel>> updatePetCategory(PetCategoryModel parameters)async {
        final result = await basePetCategoriesRemoteDataSource.updatePetCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}