import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/tools/waiting_tool_parameters.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';
import 'package:dartz/dartz.dart';
import 'package:pet_house/domain/repository/tools/base_tools_repository.dart';


class PublishWaitingToolUseCase
    extends BaseUseCase<PetToolModel, WaitingToolParameters> {
  final BaseToolsRepository baseToolsRepository;

  PublishWaitingToolUseCase(this.baseToolsRepository);

  @override
  Future<Either<Failure, PetToolModel>> call(
      WaitingToolParameters parameters) async {
    return await baseToolsRepository.publishWaitingTool(parameters);
  }
}
