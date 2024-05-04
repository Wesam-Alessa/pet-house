import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/intellectual_property_rights_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseIntellectualPropertyRightsRepository {
  Future<Either<Failure, IntellectualPropertyRightsModel>> getIntellectualPropertyRights();
  Future<Either<Failure, IntellectualPropertyRightsModel>> updateIntellectualPropertyRights(IntellectualPropertyRightsModel parameters);

}
