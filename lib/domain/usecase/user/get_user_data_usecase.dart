import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/repository/user/base_user_data_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/parameters/no_parameters.dart';

class GetUserDataUseCase extends BaseUseCase<UserModel, NoParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  GetUserDataUseCase(this.baseUserDataRepository);
  
  @override
  Future<Either<Failure, UserModel>> call(NoParameters parameters)async {
     return await baseUserDataRepository.getUserData(parameters);
  }

}