
import 'package:pet_house/data/models/parameters/objection_report_parameters.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../repository/reports/base_reports_repository.dart';

class CheckObjectionReportUseCase
    extends BaseUseCase<ObjectionReportModel, ObjectionReportParameters> {
  final BaseReportsRepository baseReportsRepository;

  CheckObjectionReportUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure,ObjectionReportModel>> call(ObjectionReportParameters parameters) async {
    return await baseReportsRepository.checkObjectionReport(parameters);
  }
}