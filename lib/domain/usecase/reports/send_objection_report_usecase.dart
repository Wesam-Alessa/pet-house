import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

 import '../../../core/network/success_message_model.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/parameters/objection_report_parameters.dart';

class SendObjectionReportUseCase
    extends BaseUseCase<SuccessMessageModel, ObjectionReportParameters> {
  final BaseReportsRepository baseReportsRepository;

  SendObjectionReportUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure,SuccessMessageModel>> call(ObjectionReportParameters parameters) async {
    return await baseReportsRepository.sendObjectionReport(parameters);
  }
}