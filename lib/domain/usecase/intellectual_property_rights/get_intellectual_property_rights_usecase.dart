import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/intellectual_property_rights_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecase/base_usecase.dart';
import '../../../data/models/parameters/no_parameters.dart';
import '../../repository/intellectual_property_rights/base_intellectual_property_rights_repository.dart';

class GetIntellectualPropertyRightsUseCase extends BaseUseCase<IntellectualPropertyRightsModel, NoParameters> {
  final BaseIntellectualPropertyRightsRepository baseIntellectualPropertyRightsRepository;

  GetIntellectualPropertyRightsUseCase(this.baseIntellectualPropertyRightsRepository);
  
  @override
  Future<Either<Failure, IntellectualPropertyRightsModel>> call(NoParameters parameters)async {
     return await baseIntellectualPropertyRightsRepository.getIntellectualPropertyRights();
  }
}
