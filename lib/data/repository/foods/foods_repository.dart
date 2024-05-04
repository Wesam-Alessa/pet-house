import 'package:dartz/dartz.dart';

import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';

import '../../../core/error/exceptions.dart';
 import '../../../domain/repository/foods/base_foods_repository.dart';
import '../../datasource/foods/foods_remote_data_source.dart';
 import '../../models/foods/pet_foods_model.dart';
import '../../models/parameters/foods/pet_food_category_parameters.dart';
import '../../models/parameters/foods/remove_food_reports_parameters.dart';
import '../../models/parameters/foods/waiting_food_parameters.dart';

class FoodsRepository extends BaseFoodsRepository{
  final BaseFoodsRemoteDataSource baseFoodsRemoteDataSource;
  FoodsRepository(this.baseFoodsRemoteDataSource);

  @override
  Future<Either<Failure, List<PetFoodsModel>>> getFoods(PetFoodCategoryParameters parameters)async {
      final result = await baseFoodsRemoteDataSource.getFoods(parameters);
      try {
        return Right(result);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.statusMessage));
      }
  }

  @override
  Future<Either<Failure, PetFoodsModel>> addNewFood(PetFoodsModel parameters)async {
    final result = await baseFoodsRemoteDataSource.addNewFood(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetFoodsModel>>> getFoodsReported() async {
    final result = await baseFoodsRemoteDataSource.getFoodsReported();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetFoodsModel>>> getWaitingFoods() async {
    final result = await baseFoodsRemoteDataSource.getWaitingFoods();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, PetFoodsModel>> publishWaitingFood(WaitingFoodParameters parameters) async {
    final result = await baseFoodsRemoteDataSource.publishWaitingFood(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> removeFoodReports(RemoveFoodReportsParameters parameters) async {
    final result = await baseFoodsRemoteDataSource.removeFoodReports(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetFoodsModel>>> search(SearchParameters parameters) async {
    final result = await baseFoodsRemoteDataSource.search(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}