import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
 import 'package:dartz/dartz.dart';

import '../../../../data/models/foods/pet_foods_model.dart';
import '../../../../data/models/parameters/no_parameters.dart';
import '../../../repository/foods/base_foods_repository.dart';

class GetWaitingFoodsUseCase extends BaseUseCase<List<PetFoodsModel>, NoParameters> {
  final BaseFoodsRepository baseFoodsRepository;

  GetWaitingFoodsUseCase(this.baseFoodsRepository);

  @override
  Future<Either<Failure, List<PetFoodsModel>>> call(NoParameters parameters)async {
    return await baseFoodsRepository.getWaitingFoods();
  }

}
