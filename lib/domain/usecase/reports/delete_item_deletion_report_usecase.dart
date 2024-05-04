import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/success_message_model.dart';
import '../../../core/usecase/base_usecase.dart';

class DeleteItemDeletionReportUseCase extends BaseUseCase<SuccessMessageModel, DeleteItemDeletionReportParameters> {
  final BaseReportsRepository baseReportsRepository;

  DeleteItemDeletionReportUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure, SuccessMessageModel>> call(DeleteItemDeletionReportParameters parameters) async {
    return await baseReportsRepository.deleteItemDeletionReport(parameters);
  }
}
