import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../data/models/tools/pet_tool_category.dart';
import '../../../repository/categories/base_tools_category_repository.dart';

class AddNewToolsCategoriesUseCase extends BaseUseCase<List<PetToolCategoryModel>, PetToolCategoryModel> {
  final BaseToolsCategoriesRepository baseToolsCategoriesRepository;

  AddNewToolsCategoriesUseCase(this.baseToolsCategoriesRepository);

  @override
  Future<Either<Failure, List<PetToolCategoryModel>>> call(PetToolCategoryModel parameters)async {
    return await baseToolsCategoriesRepository.addNewToolsCategory(parameters);
  }
}
