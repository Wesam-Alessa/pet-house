import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/models/parameters/remove_pet_reports_parameters.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:pet_house/data/models/pet_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/constant/api_constant.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../models/parameters/pets_category_parameters.dart';
import '../../models/parameters/waiting_pet_parameters.dart';
import '../../models/search/search_model.dart';

abstract class BasePetRemoteDataSource {
  Future<List<PetModel>> getPets(PetCategoryParameters parameters);
  Future<PetModel> addNewPet(PetModel parameters);
  Future<List<PetModel>> getWaitingPets();
  Future<PetModel> publishWaitingPet(WaitingPetParameters parameters);
  Future<List<PetModel>> getPetsReported();
  Future<SuccessMessageModel> removePetReports(
      RemovePetReportsParameters parameters);
   Future<SearchModel> search(SearchParameters parameters);
}

class PetRemoteDataSource extends BasePetRemoteDataSource {
  @override
  Future<List<PetModel>> getPets(PetCategoryParameters parameters) async {
    final response =
        await http.get(Uri.parse(ApiConstance.baseUrl + ApiConstance.getPets + parameters.category ));
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetModel>.from(
        (res as List).map(
          (e) {
            return PetModel.fromMap(e);
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

  Future<void> createOwner(List<dynamic> res) async {
    for (var value in res) {
      // value['owner'] = await getOwner(value['seller']['id']);
      log("${value['name']} ::::::: ${value['seller']}");
    }
  }

  Future<Map<String, dynamic>> getOwner(String id) async {
    String token = await getLocalData(key: "token");
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getUserData),
        headers: {
          'uid': id,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return res;
    } else {
      return {};
    }
  }

  @override
  Future<PetModel> addNewPet(PetModel parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.addPet),
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
      log(res.toString());
      return PetModel.fromMap(res);
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

  void setLocalData({required String key, required String val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString(key, val);
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }

  @override
  Future<List<PetModel>> getWaitingPets() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getWaitingPets),
        headers: {
          'uid': uid,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetModel>.from(
        (res as List).map(
          (e) {
            return PetModel.fromMap(e);
          },
        ),
      );
    } else {
      log(response.toString());
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<PetModel> publishWaitingPet(WaitingPetParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.publishingWaitingPets),
      headers: {
        'uid': uid,
        'x-auth-token': token,
        'pid': parameters.petID,
      },
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return PetModel.fromMap(res);
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
  Future<List<PetModel>> getPetsReported() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getPetsReported),
        headers: {
          'uid': uid,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      //log(res.toString());
      return List<PetModel>.from(
        (res as List).map(
          (e) {
            return PetModel.fromMap(e);
          },
        ),
      );
    } else {
      log(response.toString());
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<SuccessMessageModel> removePetReports(RemovePetReportsParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.delete(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.removePetReports),
        headers: {
          'uid': uid,
          'x-auth-token': token,
          'pid': parameters.petID,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res.toString(),
          success: true);
    } else {
      log(response.toString());
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }
  
  @override
  Future<SearchModel> search(SearchParameters parameters)  async {
    final response =
        await http.get(Uri.parse(ApiConstance.baseUrl + ApiConstance.search + parameters.text ));
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return SearchModel.fromJson(res);
      //   List<PetModel>.from(
      //   (res as List).map(
      //     (e) {
      //       return PetModel.fromMap(e);
      //     },
      //   ),
      // );
    } else {
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }
}
