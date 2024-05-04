import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../data/models/parameters/no_parameters.dart';
import '../../../../data/models/tools/pet_tool_category.dart';
import '../../../repository/categories/base_tools_category_repository.dart';

class GetToolsCategoriesUseCase extends BaseUseCase<List<PetToolCategoryModel>, NoParameters> {
  final BaseToolsCategoriesRepository baseToolsCategoriesRepository;

  GetToolsCategoriesUseCase(this.baseToolsCategoriesRepository);

  @override
  Future<Either<Failure, List<PetToolCategoryModel>>> call(NoParameters parameters)async {
    return await baseToolsCategoriesRepository.getToolsCategories();
  }
}
