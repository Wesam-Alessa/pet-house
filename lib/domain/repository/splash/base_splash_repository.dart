import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/splash_model.dart';

abstract class BaseSplashRepository {
  Future<Either<Failure, List<SplashModel>>> getSplashes();
}
