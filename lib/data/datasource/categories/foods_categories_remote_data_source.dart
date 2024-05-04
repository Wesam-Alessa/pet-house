import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pet_house/core/network/error_message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api_constant.dart';
import '../../../core/error/exceptions.dart';
import '../../models/foods/pet_food_category.dart';

abstract class BasePetFoodsCategoriesRemoteDataSource {
  Future<List<PetFoodsCategoryModel>> getPetFoodsCategories();
  Future<List<PetFoodsCategoryModel>> addNewPetFoodsCategory(PetFoodsCategoryModel parameters);
  Future<PetFoodsCategoryModel> updatePetFoodsCategory(PetFoodsCategoryModel parameters);
}

class PetFoodsCategoriesRemoteDataSource extends BasePetFoodsCategoriesRemoteDataSource {
  @override
  Future<List<PetFoodsCategoryModel>> getPetFoodsCategories()async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getPetFoodsCategories),
        headers: {
          'x-auth-token': token,
          'uid': uid,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetFoodsCategoryModel>.from(
        (res as List).map(
              (e) => PetFoodsCategoryModel.fromMap(e),
        ),
      );
    } else {
      log(response.body.toString());
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body.toString(),
              success: false));
    }
  }

  @override
  Future<List<PetFoodsCategoryModel>> addNewPetFoodsCategory(PetFoodsCategoryModel parameters)async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.addNewPetFoodsCategory),
    );
    // add file to request
    if (parameters.picture != null) {
      var fileStream = http.ByteStream(parameters.picture!.openRead());
      var fileLength = await parameters.picture!.length();
      var multipartFile = http.MultipartFile('file', fileStream, fileLength,
          filename: parameters.picture!.path.split('/').last);
      request.files.add(multipartFile);
    }
    request.headers.addAll({'x-auth-token': token, 'uid': uid});
    request.fields.addAll({'label': parameters.label});
    var response = await request.send();

    if (response.statusCode == 200) {
      List<PetFoodsCategoryModel> list = [];
      list = await getPetFoodsCategories();
      return list;
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
              jsonDecode(await response.stream.bytesToString())));
    }
  }

  @override
  Future<PetFoodsCategoryModel> updatePetFoodsCategory(PetFoodsCategoryModel parameters)async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.updatePetFoodsCategory),
    );
    // add file to request
    if (parameters.picture != null) {
      var fileStream = http.ByteStream(parameters.picture!.openRead());
      var fileLength = await parameters.picture!.length();
      var multipartFile = http.MultipartFile('file', fileStream, fileLength,
          filename: parameters.picture!.path.split('/').last);
      request.files.add(multipartFile);
    }
    request.headers
        .addAll({'x-auth-token': token, 'uid': uid, 'cid': parameters.id});
    request.fields.addAll({
      'label': parameters.label,
      'imageUrl': parameters.imageUrl,
      'hidden': parameters.hidden.toString(),
    });
    var response = await request.send();

    if (response.statusCode == 200) {
      var res = await jsonDecode(await response.stream.bytesToString());
      return PetFoodsCategoryModel.fromMap(res);
    } else {
      var res = jsonDecode(await response.stream.bytesToString());
      log(res.toString());
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res['errors'],
              success: false));
    }
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }
}
