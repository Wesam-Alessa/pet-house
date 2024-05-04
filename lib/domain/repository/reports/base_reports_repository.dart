import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/data/models/parameters/objection_report_parameters.dart';
import 'package:pet_house/data/models/reports/feedback_report_model.dart';
import 'package:pet_house/data/models/reports/item_deletion_report_model.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/success_message_model.dart';
import '../../../data/models/parameters/feedback_report_parameters.dart';

abstract class BaseReportsRepository {
  Future<Either<Failure, SuccessMessageModel>> postItemDeletionReport(
      ItemDeletionReportParameters parameters);
  Future<Either<Failure, List<ItemDeletionReportModel>>>
      getItemDeletionReports();
  Future<Either<Failure, SuccessMessageModel>> deleteItemDeletionReport(
      DeleteItemDeletionReportParameters parameters);
  Future<Either<Failure, SuccessMessageModel>> addReport(
      AddReportParameters parameters);
  Future<Either<Failure, List<FeedbackReportModel>>> getFeedbackReports();
  Future<Either<Failure, SuccessMessageModel>> sendFeedbackReport(
      FeedbackReportParameters parameters);
  Future<Either<Failure, SuccessMessageModel>> removeFeedbackReport(
      FeedbackReportParameters parameters);
  Future<Either<Failure, SuccessMessageModel>> sendObjectionReport(
      ObjectionReportParameters parameters);
  Future<Either<Failure, ObjectionReportModel>> checkObjectionReport(
      ObjectionReportParameters parameters);
  Future<Either<Failure, List<ObjectionReportModel>>> getObjectionReports();
  Future<Either<Failure, ObjectionReportModel>> answerOnobjectionReport(ObjectionReportModel parameters);
}
