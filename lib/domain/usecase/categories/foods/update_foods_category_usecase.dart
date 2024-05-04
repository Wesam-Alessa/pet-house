import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../data/models/foods/pet_food_category.dart';
import '../../../repository/categories/base_pet_foods_category_repository.dart';

class UpdatePetFoodsCategoryUseCase extends BaseUseCase<PetFoodsCategoryModel, PetFoodsCategoryModel> {
  final BasePetFoodsCategoriesRepository basePetFoodsCategoriesRepository;

  UpdatePetFoodsCategoryUseCase(this.basePetFoodsCategoriesRepository);

  @override
  Future<Either<Failure, PetFoodsCategoryModel>> call(PetFoodsCategoryModel parameters)async {
    return await basePetFoodsCategoriesRepository.updatePetFoodsCategory(parameters);
  }
}
