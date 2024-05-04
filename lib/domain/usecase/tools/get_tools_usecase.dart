import 'package:dartz/dartz.dart';
import 'package:pet_house/data/models/parameters/tools/pet_tool_category_parameters.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../repository/tools/base_tools_repository.dart';

class GetToolsUseCase extends BaseUseCase<List<PetToolModel>, PetToolCategoryParameters> {
  final BaseToolsRepository  baseToolsRepository;

  GetToolsUseCase(this.baseToolsRepository);

  @override
  Future<Either<Failure, List<PetToolModel>>> call(PetToolCategoryParameters parameters)async {
    return await baseToolsRepository.getTools(parameters);
  }
}
