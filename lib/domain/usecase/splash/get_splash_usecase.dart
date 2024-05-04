import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/domain/repository/splash/base_splash_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/parameters/no_parameters.dart';
import '../../../data/models/splash_model.dart';

class GetSplasUseCase extends BaseUseCase<List<SplashModel>,NoParameters>{
  final BaseSplashRepository baseSplashRepository;

  GetSplasUseCase(this.baseSplashRepository);
  
  @override
  Future<Either<Failure, List<SplashModel>>> call(parameters) async{
    return await baseSplashRepository.getSplashes();
  }

}