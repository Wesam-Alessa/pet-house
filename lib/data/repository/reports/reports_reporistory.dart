import 'package:pet_house/data/datasource/reports/reports_remote_data_source.dart';
import 'package:pet_house/data/models/parameters/feedback_report_parameters.dart';
import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/parameters/objection_report_parameters.dart';
import 'package:pet_house/data/models/reports/feedback_report_model.dart';
import 'package:pet_house/data/models/reports/item_deletion_report_model.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/success_message_model.dart';

class ReportsRepository extends BaseReportsRepository {
  final BaseReportsRemoteDataSource baseReportsDataSource;
  ReportsRepository(this.baseReportsDataSource);

  @override
  Future<Either<Failure, SuccessMessageModel>> postItemDeletionReport(
      ItemDeletionReportParameters parameters) async {
    final result =
        await baseReportsDataSource.postItemDeletionReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<ItemDeletionReportModel>>>
      getItemDeletionReports() async {
    final result = await baseReportsDataSource.getItemDeletionReports();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> deleteItemDeletionReport(
      DeleteItemDeletionReportParameters parameters) async {
    final result =
        await baseReportsDataSource.deleteItemDeletionReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> addReport(
      AddReportParameters parameters) async {
    final result = await baseReportsDataSource.addReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<FeedbackReportModel>>>
      getFeedbackReports() async {
    final result = await baseReportsDataSource.getFeedbackReports();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> sendFeedbackReport(
      FeedbackReportParameters parameters) async {
    final result = await baseReportsDataSource.sendFeedbackReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> removeFeedbackReport(
      FeedbackReportParameters parameters) async {
    final result = await baseReportsDataSource.removeFeedbackReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> sendObjectionReport(
      ObjectionReportParameters parameters) async {
    final result = await baseReportsDataSource.sendObjectionReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, ObjectionReportModel>> checkObjectionReport(ObjectionReportParameters parameters)  async {
    final result = await baseReportsDataSource.checkObjectionReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  
  @override
  Future<Either<Failure, List<ObjectionReportModel>>> getObjectionReports() async {
    final result = await baseReportsDataSource.getObjectionReports();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  
  @override
  Future<Either<Failure, ObjectionReportModel>> answerOnobjectionReport(ObjectionReportModel parameters) async {
    final result = await baseReportsDataSource.answerOnObjectionReport(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
