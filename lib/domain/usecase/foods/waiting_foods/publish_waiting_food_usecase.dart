import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
  import 'package:dartz/dartz.dart';

import '../../../../data/models/foods/pet_foods_model.dart';
import '../../../../data/models/parameters/foods/waiting_food_parameters.dart';
import '../../../repository/foods/base_foods_repository.dart';


class PublishWaitingFoodUseCase
    extends BaseUseCase<PetFoodsModel, WaitingFoodParameters> {
  final BaseFoodsRepository baseFoodsRepository;

  PublishWaitingFoodUseCase(this.baseFoodsRepository);

  @override
  Future<Either<Failure, PetFoodsModel>> call(
      WaitingFoodParameters parameters) async {
    return await baseFoodsRepository.publishWaitingFood(parameters);
  }
}
