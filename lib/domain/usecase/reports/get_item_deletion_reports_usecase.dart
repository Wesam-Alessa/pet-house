import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/parameters/no_parameters.dart';
import 'package:pet_house/data/models/reports/item_deletion_report_model.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:dartz/dartz.dart';

 import '../../../core/usecase/base_usecase.dart';

class GetItemDeletionReportsUseCase
    extends BaseUseCase<List<ItemDeletionReportModel>, NoParameters> {
  final BaseReportsRepository baseReportsRepository;

  GetItemDeletionReportsUseCase(this.baseReportsRepository);

  @override
  Future<Either<Failure, List<ItemDeletionReportModel>>> call(NoParameters parameters) async {
    return await baseReportsRepository.getItemDeletionReports();
  }
}