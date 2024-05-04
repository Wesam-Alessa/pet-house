import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:pet_house/domain/repository/categories/base_pet_category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';

class UpdatePetCategoriesUseCase extends BaseUseCase<PetCategoryModel, PetCategoryModel> {
  final BasePetCategoriesRepository basePetCategoriesRepository;

  UpdatePetCategoriesUseCase(this.basePetCategoriesRepository);
  
  @override
  Future<Either<Failure, PetCategoryModel>> call(PetCategoryModel parameters)async {
     return await basePetCategoriesRepository.updatePetCategory(parameters);
  }


}
