import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

class AddNewPetUseCase extends BaseUseCase<PetModel, PetModel> {
  final BasePetRepository basePetRepository;

  AddNewPetUseCase(this.basePetRepository);
  
  @override
  Future<Either<Failure,PetModel>> call(PetModel parameters)async {
     return await basePetRepository.addNewPet(parameters);
  }
}
