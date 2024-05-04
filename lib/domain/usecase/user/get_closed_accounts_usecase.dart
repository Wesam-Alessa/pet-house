import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/repository/user/base_user_data_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/parameters/no_parameters.dart';

class GetClosedAccountsUseCase extends BaseUseCase<List<UserModel>, NoParameters> {
  final BaseUserDataRepository baseUserDataRepository;

  GetClosedAccountsUseCase(this.baseUserDataRepository);
  
  @override
  Future<Either<Failure, List<UserModel>>> call(NoParameters parameters)async {
     return await baseUserDataRepository.getClosedAccounts(parameters);
  }

}