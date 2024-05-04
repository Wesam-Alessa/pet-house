import 'package:pet_house/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/success_message_model.dart';
import '../../../data/models/favourites/favourites_model.dart';
import '../../../data/models/parameters/change_user_status_parameters.dart';
import '../../../data/models/parameters/fav_parameters.dart';
import '../../../data/models/parameters/no_parameters.dart';
import '../../../data/models/parameters/search_parameters.dart';
import '../../../data/models/parameters/user_parameters.dart';
import '../../../data/models/parameters/user_pet_parameters.dart';

abstract class BaseUserDataRepository {
  Future<Either<Failure, UserModel>> getUserData(NoParameters parameters);
  Future<Either<Failure, List<FavouritesModel>>>getFavourites(NoParameters parameters);
  Future<Either<Failure, UserModel>> signup(UserParameters parameters);
  Future<Either<Failure, UserModel>> signin(UserParameters parameters);
  Future<Either<Failure, UserModel>> updateUserData(UserParameters parameters);
  Future<Either<Failure, List<FavouritesModel>>> removeFavItem(
      FavParameters parameters);
  Future<Either<Failure, UserModel>> addFavItem(
      FavParameters parameters);
  Future<Either<Failure, UserModel>> getUserDataByID(UserParameters parameters);
  Future<Either<Failure, SuccessMessageModel>> removeUserItem(
      UserPetParameters parameters);
    Future<Either<Failure, List<UserModel>>> searchUsers(
      SearchParameters parameters); 
  Future<Either<Failure, SuccessMessageModel>> changeUserStatusByManager(ChangeUserStatusByManagerParameters parameters);   
    Future<Either<Failure, List<UserModel>>> getClosedAccounts(
      NoParameters parameters);
}
