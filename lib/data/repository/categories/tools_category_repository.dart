import 'package:dartz/dartz.dart';
import 'package:pet_house/data/datasource/categories/tools_categories_remote_data_source.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repository/categories/base_tools_category_repository.dart';
import '../../models/tools/pet_tool_category.dart';

class ToolCategoriesRepository extends BaseToolsCategoriesRepository {
  final BaseToolsCategoriesRemoteDataSource baseToolsCategoriesRemoteDataSource;

  ToolCategoriesRepository(this.baseToolsCategoriesRemoteDataSource);

  @override
  Future<Either<Failure,List<PetToolCategoryModel>>> getToolsCategories()async {
    final result = await baseToolsCategoriesRemoteDataSource.getToolsCategories();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetToolCategoryModel>>> addNewToolsCategory(PetToolCategoryModel parameters)async {
    final result = await baseToolsCategoriesRemoteDataSource.addNewToolsCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, PetToolCategoryModel>> updateToolsCategory(PetToolCategoryModel parameters)async {
    final result = await baseToolsCategoriesRemoteDataSource.updateToolsCategory(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }


}