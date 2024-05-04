import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/success_message_model.dart';
import '../../../data/models/parameters/search_parameters.dart';
import '../../../data/models/parameters/tools/pet_tool_category_parameters.dart';
import '../../../data/models/parameters/tools/remove_tool_reports_parameters.dart';
import '../../../data/models/parameters/tools/waiting_tool_parameters.dart';
import '../../../data/models/tools/pet_tool_model.dart';

abstract class BaseToolsRepository {
  Future<Either<Failure, List<PetToolModel>>> getTools(
      PetToolCategoryParameters parameters);
  Future<Either<Failure, PetToolModel>> addNewTool(PetToolModel parameters);
  Future<Either<Failure, List<PetToolModel>>> getWaitingTools();
  Future<Either<Failure, PetToolModel>> publishWaitingTool(
      WaitingToolParameters parameters);
  Future<Either<Failure, List<PetToolModel>>> getToolsReported();
  Future<Either<Failure, SuccessMessageModel>> removeToolReports(
      RemoveToolReportsParameters parameters);
  Future<Either<Failure, List<PetToolModel>>> search(SearchParameters parameters);
}