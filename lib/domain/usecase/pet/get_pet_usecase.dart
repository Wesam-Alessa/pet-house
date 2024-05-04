import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/parameters/pets_category_parameters.dart';

class GetPetUseCase extends BaseUseCase<List<PetModel>, PetCategoryParameters> {
  final BasePetRepository basePetRepository;

  GetPetUseCase(this.basePetRepository);
  
  @override
  Future<Either<Failure, List<PetModel>>> call(PetCategoryParameters parameters)async {
     return await basePetRepository.getPets(parameters);
  }
}
