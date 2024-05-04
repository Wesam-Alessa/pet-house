import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:dartz/dartz.dart';
import 'package:pet_house/domain/repository/tools/base_tools_repository.dart';

import '../../../../data/models/tools/pet_tool_model.dart';


class ToolsSearchUseCase extends BaseUseCase<List<PetToolModel>, SearchParameters> {
  final BaseToolsRepository baseToolsRepository;

  ToolsSearchUseCase(this.baseToolsRepository);

  @override
  Future<Either<Failure, List<PetToolModel>>> call(SearchParameters parameters)async {
    return await baseToolsRepository.search(parameters);
  }
}
