import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/models/foods/pet_foods_model.dart';
 import '../../../repository/foods/base_foods_repository.dart';


class FoodsSearchUseCase extends BaseUseCase<List<PetFoodsModel>, SearchParameters> {
  final BaseFoodsRepository baseFoodsRepository;

  FoodsSearchUseCase(this.baseFoodsRepository);

  @override
  Future<Either<Failure, List<PetFoodsModel>>> call(SearchParameters parameters)async {
    return await baseFoodsRepository.search(parameters);
  }
}
