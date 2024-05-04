import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/parameters/fav_parameters.dart';
import '../../../data/models/parameters/user_pet_parameters.dart';
import '../../repository/user/base_user_data_repository.dart';

class AddFavItemUseCase extends BaseUseCase<UserModel, FavParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  AddFavItemUseCase(this.baseUserDataRepository);

  @override
  Future<Either<Failure, UserModel>> call(FavParameters parameters) async {
    return await baseUserDataRepository.addFavItem(parameters);
  }
}
