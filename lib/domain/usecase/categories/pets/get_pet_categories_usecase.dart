import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:pet_house/domain/repository/categories/base_pet_category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../data/models/parameters/no_parameters.dart';

class GetPetCategoriesUseCase extends BaseUseCase<List<PetCategoryModel>, NoParameters> {
  final BasePetCategoriesRepository basePetCategoriesRepository;

  GetPetCategoriesUseCase(this.basePetCategoriesRepository);
  
  @override
  Future<Either<Failure, List<PetCategoryModel>>> call(NoParameters parameters)async {
     return await basePetCategoriesRepository.getPetCategories();
  }


}
