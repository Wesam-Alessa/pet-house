import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/core/constant/api_constant.dart';
import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/network/error_message_model.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class BasePetCategoriesRemoteDataSource {
  Future<List<PetCategoryModel>> getPetCategories();
  Future<List<PetCategoryModel>> addNewPetCategory(PetCategoryModel parameters);
  Future<PetCategoryModel> updatePetCategory(PetCategoryModel parameters);
}

class PetCategoriesRemoteDataSource extends BasePetCategoriesRemoteDataSource {
  @override
  Future<List<PetCategoryModel>> getPetCategories() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getPetcategories),
        headers: {
          'x-auth-token': token,
          'uid': uid,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetCategoryModel>.from(
        (res as List).map(
          (e) => PetCategoryModel.fromMap(e),
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
  Future<PetCategoryModel> updatePetCategory(
      PetCategoryModel parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.updatePetcategory),
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
      return PetCategoryModel.fromMap(res);
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

  @override
  Future<List<PetCategoryModel>> addNewPetCategory(
      PetCategoryModel parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.addNewPetcategory),
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
      List<PetCategoryModel> list = [];
      list = await getPetCategories();
      return list;
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
              jsonDecode(await response.stream.bytesToString())));
    }
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }
}
