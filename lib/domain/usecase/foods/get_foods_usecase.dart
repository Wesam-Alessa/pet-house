import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/foods/pet_foods_model.dart';
import '../../../data/models/parameters/foods/pet_food_category_parameters.dart';
import '../../repository/foods/base_foods_repository.dart';

class GetFoodsUseCase extends BaseUseCase<List<PetFoodsModel>, PetFoodCategoryParameters> {
  final BaseFoodsRepository  baseFoodsRepository;

  GetFoodsUseCase(this.baseFoodsRepository);

  @override
  Future<Either<Failure, List<PetFoodsModel>>> call(PetFoodCategoryParameters parameters)async {
    return await baseFoodsRepository.getFoods(parameters);
  }
}
