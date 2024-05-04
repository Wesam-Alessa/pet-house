import 'package:pet_house/core/usecase/base_usecase.dart';
 import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/success_message_model.dart';
import '../../../data/models/parameters/user_pet_parameters.dart';
import '../../repository/user/base_user_data_repository.dart';

class RemoveUserPetUseCase extends BaseUseCase<SuccessMessageModel, UserPetParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  RemoveUserPetUseCase(this.baseUserDataRepository);

  @override
  Future<Either<Failure, SuccessMessageModel>> call(UserPetParameters parameters) async {
    return await baseUserDataRepository.removeUserItem(parameters);
  }
}
