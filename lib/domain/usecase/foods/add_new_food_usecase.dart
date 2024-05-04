import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/foods/pet_foods_model.dart';
 import '../../repository/foods/base_foods_repository.dart';

class AddNewFoodUseCase extends BaseUseCase<PetFoodsModel, PetFoodsModel> {
  final BaseFoodsRepository baseFoodsRepository;

  AddNewFoodUseCase(this.baseFoodsRepository);

  @override
  Future<Either<Failure,PetFoodsModel>> call(PetFoodsModel parameters)async {
    return await baseFoodsRepository.addNewFood(parameters);
  }
}