import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/models/parameters/remove_pet_reports_parameters.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/parameters/pets_category_parameters.dart';
import '../../../data/models/parameters/waiting_pet_parameters.dart';
import '../../../data/models/search/search_model.dart';

abstract class BasePetRepository {
  Future<Either<Failure, List<PetModel>>> getPets(PetCategoryParameters parameters);
  Future<Either<Failure, PetModel>> addNewPet(PetModel parameters);
  Future<Either<Failure, List<PetModel>>> getWaitingPets();
  Future<Either<Failure, PetModel>> publishWaitingPet(
      WaitingPetParameters parameters);
  Future<Either<Failure, List<PetModel>>> getPetsReported();
  Future<Either<Failure, SuccessMessageModel>> removePetReports(
      RemovePetReportsParameters parameters);
  Future<Either<Failure, SearchModel>> search(SearchParameters parameters);
}
