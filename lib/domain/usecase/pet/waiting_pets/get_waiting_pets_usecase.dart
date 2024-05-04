import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/models/parameters/no_parameters.dart';

class GetWaitingPetsUseCase extends BaseUseCase<List<PetModel>, NoParameters> {
  final BasePetRepository basePetRepository;

  GetWaitingPetsUseCase(this.basePetRepository);
  
  @override
  Future<Either<Failure, List<PetModel>>> call(NoParameters parameters)async {
     return await basePetRepository.getWaitingPets();
  }

}
