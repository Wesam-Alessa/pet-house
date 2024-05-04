import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

 import '../../../core/network/success_message_model.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/parameters/feedback_report_parameters.dart';

class RemoveIFeedbackReportsUseCase
    extends BaseUseCase<SuccessMessageModel, FeedbackReportParameters> {
  final BaseReportsRepository baseReportsRepository;

  RemoveIFeedbackReportsUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure,SuccessMessageModel>> call(FeedbackReportParameters parameters) async {
    return await baseReportsRepository.removeFeedbackReport(parameters);
  }
}