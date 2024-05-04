import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/models/parameters/foods/remove_food_reports_parameters.dart';
import '../../../repository/foods/base_foods_repository.dart';

class RemoveFoodReportsUseCase extends BaseUseCase<SuccessMessageModel, RemoveFoodReportsParameters> {
  final BaseFoodsRepository baseFoodsRepository;

  RemoveFoodReportsUseCase(this.baseFoodsRepository);

  @override
  Future<Either<Failure, SuccessMessageModel>> call(RemoveFoodReportsParameters parameters)async {
    return await baseFoodsRepository.removeFoodReports(parameters);
  }
}