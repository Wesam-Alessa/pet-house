import 'package:dartz/dartz.dart';

import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';

import 'package:pet_house/data/models/parameters/tools/pet_tool_category_parameters.dart';
import 'package:pet_house/data/models/parameters/tools/remove_tool_reports_parameters.dart';
import 'package:pet_house/data/models/parameters/tools/waiting_tool_parameters.dart';

import 'package:pet_house/data/models/tools/pet_tool_model.dart';

import '../../../core/error/exceptions.dart';
import '../../../domain/repository/tools/base_tools_repository.dart';
import '../../datasource/tools/tools_remote_data_source.dart';

class ToolsRepository extends BaseToolsRepository{
  final BaseToolsRemoteDataSource baseToolsRemoteDataSource;
  ToolsRepository(this.baseToolsRemoteDataSource);

  @override
  Future<Either<Failure, List<PetToolModel>>> getTools(PetToolCategoryParameters parameters)async {
      final result = await baseToolsRemoteDataSource.getTools(parameters);
      try {
        return Right(result);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.statusMessage));
      }
  }

  @override
  Future<Either<Failure, PetToolModel>> addNewTool(PetToolModel parameters)async {
    final result = await baseToolsRemoteDataSource.addNewTool(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetToolModel>>> getToolsReported() async {
    final result = await baseToolsRemoteDataSource.getToolsReported();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetToolModel>>> getWaitingTools() async {
    final result = await baseToolsRemoteDataSource.getWaitingTools();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, PetToolModel>> publishWaitingTool(WaitingToolParameters parameters) async {
    final result = await baseToolsRemoteDataSource.publishWaitingTool(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> removeToolReports(RemoveToolReportsParameters parameters) async {
    final result = await baseToolsRemoteDataSource.removeToolReports(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetToolModel>>> search(SearchParameters parameters) async {
    final result = await baseToolsRemoteDataSource.search(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}