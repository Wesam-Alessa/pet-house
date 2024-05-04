import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
 import 'package:pet_house/domain/repository/user/base_user_data_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/favourites/favourites_model.dart';
import '../../../data/models/parameters/no_parameters.dart';

class GetFavouritesUseCase extends BaseUseCase<List<FavouritesModel>, NoParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  GetFavouritesUseCase(this.baseUserDataRepository);

  @override
  Future<Either<Failure, List<FavouritesModel>>> call(NoParameters parameters)async {
    return await baseUserDataRepository.getFavourites(parameters);
  }

}