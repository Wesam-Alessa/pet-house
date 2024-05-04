import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/intellectual_property_rights_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecase/base_usecase.dart';
import '../../repository/intellectual_property_rights/base_intellectual_property_rights_repository.dart';

class UpdateIntellectualPropertyRightsUseCase extends BaseUseCase<IntellectualPropertyRightsModel, IntellectualPropertyRightsModel> {
  final BaseIntellectualPropertyRightsRepository baseIntellectualPropertyRightsRepository;

  UpdateIntellectualPropertyRightsUseCase(this.baseIntellectualPropertyRightsRepository);
  
  @override
  Future<Either<Failure, IntellectualPropertyRightsModel>> call(IntellectualPropertyRightsModel parameters)async {
     return await baseIntellectualPropertyRightsRepository.updateIntellectualPropertyRights(parameters);
  }
}
