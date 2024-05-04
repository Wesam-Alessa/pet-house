import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/tools/pet_tool_model.dart';
import '../../repository/tools/base_tools_repository.dart';

class AddNewToolUseCase extends BaseUseCase<PetToolModel, PetToolModel> {
  final BaseToolsRepository baseToolsRepository;

  AddNewToolUseCase(this.baseToolsRepository);

  @override
  Future<Either<Failure,PetToolModel>> call(PetToolModel parameters)async {
    return await baseToolsRepository.addNewTool(parameters);
  }
}