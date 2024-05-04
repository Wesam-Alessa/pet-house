import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/models/parameters/tools/remove_tool_reports_parameters.dart';
import '../../../repository/tools/base_tools_repository.dart';

class RemoveToolReportsUseCase extends BaseUseCase<SuccessMessageModel, RemoveToolReportsParameters> {
  final BaseToolsRepository baseToolsRepository;

  RemoveToolReportsUseCase(this.baseToolsRepository);

  @override
  Future<Either<Failure, SuccessMessageModel>> call(RemoveToolReportsParameters parameters)async {
    return await baseToolsRepository.removeToolReports(parameters);
  }
}