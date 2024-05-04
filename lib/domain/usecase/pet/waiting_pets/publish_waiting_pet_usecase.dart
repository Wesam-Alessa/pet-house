import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/models/parameters/waiting_pet_parameters.dart';

class PublishWaitingPetUseCase
    extends BaseUseCase<PetModel, WaitingPetParameters> {
  final BasePetRepository basePetRepository;

  PublishWaitingPetUseCase(this.basePetRepository);

  @override
  Future<Either<Failure, PetModel>> call(
      WaitingPetParameters parameters) async {
    return await basePetRepository.publishWaitingPet(parameters);
  }
}
