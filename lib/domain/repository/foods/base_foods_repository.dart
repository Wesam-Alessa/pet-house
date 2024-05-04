import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/success_message_model.dart';
import '../../../data/models/foods/pet_foods_model.dart';
import '../../../data/models/parameters/foods/pet_food_category_parameters.dart';
import '../../../data/models/parameters/foods/remove_food_reports_parameters.dart';
import '../../../data/models/parameters/foods/waiting_food_parameters.dart';
import '../../../data/models/parameters/search_parameters.dart';
abstract class BaseFoodsRepository {
  Future<Either<Failure, List<PetFoodsModel>>> getFoods(
      PetFoodCategoryParameters parameters);
  Future<Either<Failure, PetFoodsModel>> addNewFood(PetFoodsModel parameters);
  Future<Either<Failure, List<PetFoodsModel>>> getWaitingFoods();
  Future<Either<Failure, PetFoodsModel>> publishWaitingFood(
      WaitingFoodParameters parameters);
  Future<Either<Failure, List<PetFoodsModel>>> getFoodsReported();
  Future<Either<Failure, SuccessMessageModel>> removeFoodReports(
      RemoveFoodReportsParameters parameters);
  Future<Either<Failure, List<PetFoodsModel>>> search(SearchParameters parameters);
}