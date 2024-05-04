import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../data/models/foods/pet_food_category.dart';
import '../../../repository/categories/base_pet_foods_category_repository.dart';

class AddNewPetFoodsCategoriesUseCase extends BaseUseCase<List<PetFoodsCategoryModel>, PetFoodsCategoryModel> {
  final BasePetFoodsCategoriesRepository basePetFoodsCategoriesRepository;

  AddNewPetFoodsCategoriesUseCase(this.basePetFoodsCategoriesRepository);

  @override
  Future<Either<Failure, List<PetFoodsCategoryModel>>> call(PetFoodsCategoryModel parameters)async {
    return await basePetFoodsCategoriesRepository.addNewPetFoodsCategory(parameters);
  }
}
