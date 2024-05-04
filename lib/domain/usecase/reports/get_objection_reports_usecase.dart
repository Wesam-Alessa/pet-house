import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/parameters/no_parameters.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

 import '../../../core/usecase/base_usecase.dart';

class GetIObjectionReportsUseCase
    extends BaseUseCase<List<ObjectionReportModel>, NoParameters> {
  final BaseReportsRepository baseReportsRepository;

  GetIObjectionReportsUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure, List<ObjectionReportModel>>> call(NoParameters parameters) async {
    return await baseReportsRepository.getObjectionReports();
  }
}