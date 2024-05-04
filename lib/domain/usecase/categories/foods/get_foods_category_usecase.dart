import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../data/models/foods/pet_food_category.dart';
import '../../../../data/models/parameters/no_parameters.dart';
import '../../../repository/categories/base_pet_foods_category_repository.dart';

class GetPetFoodsCategoriesUseCase extends BaseUseCase<List<PetFoodsCategoryModel>, NoParameters> {
  final BasePetFoodsCategoriesRepository basePetFoodsCategoriesRepository;

  GetPetFoodsCategoriesUseCase(this.basePetFoodsCategoriesRepository);

  @override
  Future<Either<Failure, List<PetFoodsCategoryModel>>> call(NoParameters parameters)async {
    return await basePetFoodsCategoriesRepository.getPetFoodsCategories();
  }
}
