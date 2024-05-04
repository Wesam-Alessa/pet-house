import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/datasource/pet/pet_remote_data_source.dart';
import 'package:pet_house/data/models/parameters/remove_pet_reports_parameters.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:pet_house/data/models/parameters/waiting_pet_parameters.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../models/parameters/pets_category_parameters.dart';
import '../../models/search/search_model.dart';

class PetRepository extends BasePetRepository {
  final BasePetRemoteDataSource basePetRemoteDataSource;

  PetRepository(this.basePetRemoteDataSource);

  @override
  Future<Either<Failure, List<PetModel>>> getPets(PetCategoryParameters parameters) async {
    final result = await basePetRemoteDataSource.getPets(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, PetModel>> addNewPet(PetModel parameters) async {
    final result = await basePetRemoteDataSource.addNewPet(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetModel>>> getWaitingPets() async {
    final result = await basePetRemoteDataSource.getWaitingPets();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, PetModel>> publishWaitingPet(
      WaitingPetParameters parameters) async {
    final result = await basePetRemoteDataSource.publishWaitingPet(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<PetModel>>> getPetsReported() async {
    final result = await basePetRemoteDataSource.getPetsReported();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> removePetReports(
      RemovePetReportsParameters parameters) async {
    final result = await basePetRemoteDataSource.removePetReports(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SearchModel>> search(SearchParameters parameters) async {
    final result = await basePetRemoteDataSource.search(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
