import 'dart:convert';

import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/network/error_message_model.dart';
import 'package:pet_house/data/models/intellectual_property_rights_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api_constant.dart';

abstract class BaseIntellectualPropertyRightsRemoteDataSource {
  Future<IntellectualPropertyRightsModel> getIntellectualPropertyRights();
  Future<IntellectualPropertyRightsModel> updateIntellectualPropertyRights(
      IntellectualPropertyRightsModel parameters);
}

class IntellectualPropertyRightsRemoteDataSource
    extends BaseIntellectualPropertyRightsRemoteDataSource {
  void setLocalData({required String key, required String val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString(key, val);
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }

  @override
  Future<IntellectualPropertyRightsModel>
      getIntellectualPropertyRights() async {
    String token = await getLocalData(key: "token");

    final response = await http.get(
        Uri.parse(
            ApiConstance.baseUrl + ApiConstance.getIntellectualPropertyRights),
        headers: {
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      setLocalData(key: 'rid', val: res["_id"]);
      return IntellectualPropertyRightsModel.fromMap(res);
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
  Future<IntellectualPropertyRightsModel> updateIntellectualPropertyRights(
      IntellectualPropertyRightsModel parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    String rid = await getLocalData(key: 'rid');
    final response = await http.post(
        Uri.parse(
          ApiConstance.baseUrl + ApiConstance.updateIntellectualPropertyRights,
        ),
        body: {
          'text':parameters.text,
        },
        headers: {
          'x-auth-token': token,
          'uid': uid,
          'rid': rid,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return IntellectualPropertyRightsModel.fromMap(res);
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
