import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api_constant.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/network/success_message_model.dart';
import '../../models/parameters/search_parameters.dart';
import '../../models/parameters/tools/pet_tool_category_parameters.dart';
import '../../models/parameters/tools/remove_tool_reports_parameters.dart';
import '../../models/parameters/tools/waiting_tool_parameters.dart';
import '../../models/tools/pet_tool_model.dart';
abstract class BaseToolsRemoteDataSource{
  Future<List<PetToolModel>> getTools(PetToolCategoryParameters parameters);
  Future<PetToolModel> addNewTool(PetToolModel parameters);
  Future<List<PetToolModel>> getWaitingTools();
  Future<PetToolModel> publishWaitingTool(WaitingToolParameters parameters);
  Future<List<PetToolModel>> getToolsReported();
  Future<SuccessMessageModel> removeToolReports(
      RemoveToolReportsParameters parameters);
  Future<List<PetToolModel>> search(SearchParameters parameters);
}

class ToolsRemoteDataSource extends BaseToolsRemoteDataSource{

  @override
  Future<List<PetToolModel>> getTools(PetToolCategoryParameters parameters)async {
    String token = await getLocalData(key: "token");
    final response =
    await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getTools + parameters.category ),
        headers: {
          'x-auth-token': token,
        }
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return List<PetToolModel>.from(
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

  @override
  Future<PetToolModel> addNewTool(PetToolModel parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.addNewTool),
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

      return PetToolModel.fromMap(res);
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
  Future<List<PetToolModel>> getWaitingTools() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getWaitingTools),
        headers: {
          'uid': uid,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetToolModel>.from(
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

  @override
  Future<PetToolModel> publishWaitingTool(WaitingToolParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.publishingWaitingTool),
      headers: {
        'uid': uid,
        'x-auth-token': token,
        'iid': parameters.toolID,
      },
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return PetToolModel.fromMap(res);
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
  Future<List<PetToolModel>> getToolsReported() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getToolsReported),
        headers: {
          'uid': uid,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return List<PetToolModel>.from(
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

  @override
  Future<SuccessMessageModel> removeToolReports(RemoveToolReportsParameters parameters)async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.delete(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.removeToolReports),
        headers: {
          'uid': uid,
          'x-auth-token': token,
          'iid': parameters.toolID,
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
  Future<List<PetToolModel>> search(SearchParameters parameters)  async {
    final response =
    await http.get(Uri.parse(ApiConstance.baseUrl + ApiConstance.searchTools + parameters.text ));
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<PetToolModel>.from(
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