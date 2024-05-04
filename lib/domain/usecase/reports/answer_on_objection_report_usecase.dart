import 'package:pet_house/core/error/failure.dart';
 import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

 import '../../../core/usecase/base_usecase.dart';

class AnswerOnobjectionReportUseCase extends BaseUseCase<ObjectionReportModel, ObjectionReportModel> {
  final BaseReportsRepository baseReportsRepository;

  AnswerOnobjectionReportUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure, ObjectionReportModel>> call(
      ObjectionReportModel parameters) async {
    return await baseReportsRepository.answerOnobjectionReport(parameters);
  }
}