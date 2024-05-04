import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/tools/pet_tool_category.dart';

abstract class BaseToolsCategoriesRepository {
  Future<Either<Failure, List<PetToolCategoryModel>>> getToolsCategories();
  Future<Either<Failure, List<PetToolCategoryModel>>> addNewToolsCategory(PetToolCategoryModel parameters);
  Future<Either<Failure, PetToolCategoryModel>> updateToolsCategory(PetToolCategoryModel parameters);
}