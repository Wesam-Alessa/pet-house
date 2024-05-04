import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/models/parameters/no_parameters.dart';
import '../../../repository/tools/base_tools_repository.dart';

class GetWaitingToolsUseCase extends BaseUseCase<List<PetToolModel>, NoParameters> {
  final BaseToolsRepository baseToolsRepository;

  GetWaitingToolsUseCase(this.baseToolsRepository);

  @override
  Future<Either<Failure, List<PetToolModel>>> call(NoParameters parameters)async {
    return await baseToolsRepository.getWaitingTools();
  }

}
