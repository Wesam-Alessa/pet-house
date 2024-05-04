import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/parameters/no_parameters.dart';
import 'package:pet_house/data/models/reports/feedback_report_model.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

 import '../../../core/usecase/base_usecase.dart';

class GetIFeedbackReportsUseCase
    extends BaseUseCase<List<FeedbackReportModel>, NoParameters> {
  final BaseReportsRepository baseReportsRepository;

  GetIFeedbackReportsUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure, List<FeedbackReportModel>>> call(NoParameters parameters) async {
    return await baseReportsRepository.getFeedbackReports();
  }
}