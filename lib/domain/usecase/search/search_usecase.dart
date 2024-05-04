import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
 import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/search/search_model.dart';


class SearchUseCase extends BaseUseCase<SearchModel, SearchParameters> {
  final BasePetRepository basePetRepository;

  SearchUseCase(this.basePetRepository);
  
  @override
  Future<Either<Failure, SearchModel>> call(SearchParameters parameters)async {
     return await basePetRepository.search(parameters);
  }
}
