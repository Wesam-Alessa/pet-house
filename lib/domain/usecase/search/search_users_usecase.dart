import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../repository/user/base_user_data_repository.dart';


class SearchUsersUseCase extends BaseUseCase<List<UserModel>, SearchParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  SearchUsersUseCase(this.baseUserDataRepository);
  
  @override
  Future<Either<Failure, List<UserModel>>> call(SearchParameters parameters)async {
     return await baseUserDataRepository.searchUsers(parameters);
  }
}