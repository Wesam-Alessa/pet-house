import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/parameters/user_parameters.dart';
import '../../repository/user/base_user_data_repository.dart';

class UpdateUserDataUseCase extends BaseUseCase<UserModel,UserParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  UpdateUserDataUseCase(this.baseUserDataRepository);
  
  @override
  Future<Either<Failure,UserModel>> call(UserParameters parameters)async {
     return await baseUserDataRepository.updateUserData(parameters);
  }


}