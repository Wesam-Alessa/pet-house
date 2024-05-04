import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/datasource/user/user_data_remote_data_source.dart';
import 'package:pet_house/data/models/parameters/change_user_status_parameters.dart';
import 'package:pet_house/data/models/parameters/no_parameters.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:pet_house/data/models/parameters/user_parameters.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/repository/user/base_user_data_repository.dart';
import 'package:dartz/dartz.dart';

import '../../models/favourites/favourites_model.dart';
import '../../models/parameters/fav_parameters.dart';
import '../../models/parameters/user_pet_parameters.dart';

class UserDataRepository extends BaseUserDataRepository {
  final BaseUserDataRemoteDataSource baseUserDataRemoteDataSourse;

  UserDataRepository(this.baseUserDataRemoteDataSourse);

  @override
  Future<Either<Failure, UserModel>> getUserData(
      NoParameters parameters) async {
    final result = await baseUserDataRemoteDataSourse.getUserData(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signup(UserParameters parameters) async {
    final result = await baseUserDataRemoteDataSourse.signup(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signin(UserParameters parameters) async {
    final result = await baseUserDataRemoteDataSourse.signin(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<FavouritesModel>>> removeFavItem(
      FavParameters parameters) async {
    final result = await baseUserDataRemoteDataSourse.removeFavItem(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserModel>> addFavItem(
      FavParameters parameters) async {
    final result = await baseUserDataRemoteDataSourse.addFavItem(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> removeUserItem(
      UserPetParameters parameters) async {
    final result = await baseUserDataRemoteDataSourse.removeUserItem(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUserData(
      UserParameters parameters) async {
    final result =
        await baseUserDataRemoteDataSourse.updateUserData(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserDataByID(
      UserParameters parameters) async {
    final result =
        await baseUserDataRemoteDataSourse.getUserDataByID(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> searchUsers(SearchParameters parameters) async {
    final result =
        await baseUserDataRemoteDataSourse.searchUsers(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, SuccessMessageModel>> changeUserStatusByManager(ChangeUserStatusByManagerParameters parameters) async {
    final result =
        await baseUserDataRemoteDataSourse.changeUserStatusByManager(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  
  @override
  Future<Either<Failure, List<UserModel>>> getClosedAccounts(NoParameters parameters) async {
    final result =
        await baseUserDataRemoteDataSourse.getClosedAccounts(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<FavouritesModel>>> getFavourites(NoParameters parameters)async {
    final result =
        await baseUserDataRemoteDataSourse.getFavourites(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

}
