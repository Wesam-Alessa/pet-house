import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api_constant.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/network/success_message_model.dart';
import '../../models/foods/pet_foods_model.dart';
import '../../models/parameters/foods/pet_food_category_parameters.dart';
import '../../models/parameters/foods/remove_food_reports_parameters.dart';
import '../../models/parameters/foods/waiting_food_parameters.dart';
import '../../models/parameters/search_parameters.dart';
import '../../models/tools/pet_tool_model.dart';

abstract class BaseFoodsRemoteDataSource{
  Future<List<PetFoodsModel>> getFoods(PetFoodCategoryParameters parameters);
  Future<PetFoodsModel> addNewFood(PetFoodsModel parameters);
  Future<List<PetFoodsModel>> getWaitingFoods();
  Future<PetFoodsModel> publishWaitingFood(WaitingFoodParameters parameters);
  Future<List<PetFoodsModel>> getFoodsReported();
  Future<SuccessMessageModel> removeFoodReports(
      RemoveFoodReportsParameters parameters);
  Future<List<PetFoodsModel>> search(SearchParameters parameters);
}

class FoodsRemoteDataSource extends BaseFoodsRemoteDataSource{

  @override
  Future<List<PetFoodsModel>> getFoods(PetFoodCategoryParameters parameters)async {
    String token = await getLocalData(key: "token");
    final response =
    await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getFoods + parameters.category ),
        headers: {
          'x-auth-token': token,
        }
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return List<PetFoodsModel>.from(
        (res as List).map(
              (e) {
            return PetFoodsModel.fromMap(e);
          },
        ),
      );
    } else {
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<PetFoodsModel> addNewFood(PetFoodsModel parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.addNewFood),
    );

    for (int i = 0; i < parameters.pictures.length; i++) {
      var fileStream = http.ByteStream(parameters.pictures[i].openRead());
      var fileLength = await parameters.pictures[i].length();
      var multipartFile = http.MultipartFile('image$i', fileStream, fileLength,
          filename: parameters.pictures[i].path.split('/').last);
      request.files.add(multipartFile);
    }
    request.headers['x-auth-token'] = token;
    request.headers['uid'] = uid;
    request.fields.addAll(parameters.toMap());
    var response = await request.send();
    if (response.statusCode == 200) {

      var res = jsonDecode(await response.stream.bytesToString());
      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");

      return PetFoodsModel.fromMap(res);
    } else {

      var res = jsonDecode(await response.stream.bytesToString());
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res['message'],
              success: false));
    }
  }

  @override
  Future<List<PetFoodsModel>> getWaitingFoods() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getWaitingFoods),
        headers: {
          'uid': uid,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetFoodsModel>.from(
        (res as List).map(
              (e) {
            return PetFoodsModel.fromMap(e);
          },
        ),
      );
    } else {
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<PetFoodsModel> publishWaitingFood(WaitingFoodParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.publishingWaitingFood),
      headers: {
        'uid': uid,
        'x-auth-token': token,
        'iid': parameters.foodID,
      },
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return PetFoodsModel.fromMap(res);
    } else {
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<List<PetFoodsModel>> getFoodsReported() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getFoodsReported),
        headers: {
          'uid': uid,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return List<PetFoodsModel>.from(
        (res as List).map(
              (e) {
            return PetFoodsModel.fromMap(e);
          },
        ),
      );
    } else {

      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<SuccessMessageModel> removeFoodReports(RemoveFoodReportsParameters parameters)async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.delete(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.removeFoodReports),
        headers: {
          'uid': uid,
          'x-auth-token': token,
          'iid': parameters.foodID,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res.toString(),
          success: true);
    } else {
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<List<PetFoodsModel>> search(SearchParameters parameters)  async {
    final response =
    await http.get(Uri.parse(ApiConstance.baseUrl + ApiConstance.searchFoods + parameters.text ));
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetFoodsModel>.from(
        (res as List).map(
              (e) {
            return PetToolModel.fromMap(e);
          },
        ),
      );
    } else {
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }



  void setLocalData({required String key, required String val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString(key, val);
  }
  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }
}