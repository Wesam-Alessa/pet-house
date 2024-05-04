// ignore_for_file: file_names

import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/success_message_model.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/parameters/change_user_status_parameters.dart';
import '../../repository/user/base_user_data_repository.dart';

class ChangeUserStatusByManagerUseCase extends BaseUseCase<SuccessMessageModel, ChangeUserStatusByManagerParameters> {
final BaseUserDataRepository baseUserDataRepository;
  ChangeUserStatusByManagerUseCase(this.baseUserDataRepository);

  @override
  Future<Either<Failure, SuccessMessageModel>> call(
      ChangeUserStatusByManagerParameters parameters) async {
    return await baseUserDataRepository.changeUserStatusByManager(parameters);
  }
}