import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/data/datasource/splash/splash_remote_data_source.dart';
import 'package:pet_house/data/models/splash_model.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/domain/repository/splash/base_splash_repository.dart';
import 'package:dartz/dartz.dart';

class SplashRepository extends BaseSplashRepository {
  final BaseSplashRemoteDataSource baseSplashRemoteDataSourse;

  SplashRepository(this.baseSplashRemoteDataSourse);

  @override
  Future<Either<Failure, List<SplashModel>>> getSplashes() async {
    final result = await baseSplashRemoteDataSourse.getSplashes();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
