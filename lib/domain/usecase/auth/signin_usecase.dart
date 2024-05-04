import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/repository/user/base_user_data_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/parameters/user_parameters.dart';

class SignInUseCase extends BaseUseCase<UserModel, UserParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  SignInUseCase(this.baseUserDataRepository);
  
  @override
  Future<Either<Failure, UserModel>> call(UserParameters parameters)async {
     return await baseUserDataRepository.signin(parameters);
  }

}