import 'package:pet_house/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';

import 'package:pet_house/data/models/intellectual_property_rights_model.dart';

import 'package:pet_house/core/error/failure.dart';

import '../../../domain/repository/intellectual_property_rights/base_intellectual_property_rights_repository.dart';
import '../../datasource/intellectual_property_rights/intellectual_property_rights_remote_data_source.dart';

class IntellectualPropertyRightsRepository
    extends BaseIntellectualPropertyRightsRepository {
  final BaseIntellectualPropertyRightsRemoteDataSource
      baseIntellectualPropertyRightsDataSource;
  IntellectualPropertyRightsRepository(
      this.baseIntellectualPropertyRightsDataSource);
  @override
  Future<Either<Failure, IntellectualPropertyRightsModel>>
      getIntellectualPropertyRights() async {
    final result = await baseIntellectualPropertyRightsDataSource
        .getIntellectualPropertyRights();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, IntellectualPropertyRightsModel>>
      updateIntellectualPropertyRights(
          IntellectualPropertyRightsModel parameters) async {
    final result = await baseIntellectualPropertyRightsDataSource
        .updateIntellectualPropertyRights(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
