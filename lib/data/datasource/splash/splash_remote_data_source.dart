
import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/network/error_message_model.dart';
import 'package:pet_house/data/models/splash_model.dart';
import 'package:dio/dio.dart';

import '../../../core/constant/api_constant.dart';

abstract class BaseSplashRemoteDataSource {
  Future<List<SplashModel>> getSplashes();
}

class SplashRemoteDataSource extends BaseSplashRemoteDataSource {
  @override
  Future<List<SplashModel>> getSplashes() async {
    final Response response =
        await Dio().get(ApiConstance.baseUrl + ApiConstance.getSplashes);
    if (response.statusCode == 200) {
      return List<SplashModel>.from(
        (response.data as List).map(
          (e) => SplashModel.fromMap(e),
        ),
      );
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }
}
