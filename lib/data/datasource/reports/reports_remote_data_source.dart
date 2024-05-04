import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/core/network/error_message_model.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/data/models/parameters/objection_report_parameters.dart';
import 'package:pet_house/data/models/reports/item_deletion_report_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/constant/api_constant.dart';
import '../../../core/error/exceptions.dart';
import '../../models/parameters/feedback_report_parameters.dart';
import '../../models/reports/feedback_report_model.dart';
import '../../models/reports/objection_report_model.dart';

abstract class BaseReportsRemoteDataSource {
  Future<SuccessMessageModel> postItemDeletionReport(
      ItemDeletionReportParameters parameters);
  Future<List<ItemDeletionReportModel>> getItemDeletionReports();
  Future<SuccessMessageModel> deleteItemDeletionReport(
      DeleteItemDeletionReportParameters parameters);
  Future<SuccessMessageModel> addReport(AddReportParameters parameters);
  Future<List<FeedbackReportModel>> getFeedbackReports();
  Future<SuccessMessageModel> sendFeedbackReport(
      FeedbackReportParameters parameters);
  Future<SuccessMessageModel> removeFeedbackReport(
      FeedbackReportParameters parameters);
  Future<SuccessMessageModel> sendObjectionReport(
      ObjectionReportParameters parameters);
  Future<ObjectionReportModel> checkObjectionReport(
      ObjectionReportParameters parameters);
  Future<List<ObjectionReportModel>> getObjectionReports();
  Future<ObjectionReportModel>answerOnObjectionReport(ObjectionReportModel parameters);
}

class ReportsRemoteDataSource extends BaseReportsRemoteDataSource {
  @override
  Future<SuccessMessageModel> postItemDeletionReport(
      ItemDeletionReportParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.post(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.itemDeletionReport2),
      headers: {
        'uid': uid,
        'x-auth-token': token,
      },
      body: parameters.toMap(),
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
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
  Future<List<ItemDeletionReportModel>> getItemDeletionReports() async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.get(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.getItemDeletionReports),
      headers: {
        'uid': uid,
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return List<ItemDeletionReportModel>.from(
        (res as List).map(
          (e) {
            return ItemDeletionReportModel.fromMap(e);
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

  void setLocalData({required String key, required String val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString(key, val);
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }

  @override
  Future<SuccessMessageModel> deleteItemDeletionReport(
      DeleteItemDeletionReportParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    final response = await http.delete(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.deleteItemDeletionReport),
      headers: {
        'uid': uid,
        'x-auth-token': token,
        'rid': parameters.reportID,
        'pid': parameters.publisherID,
      },
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
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
  Future<SuccessMessageModel> addReport(AddReportParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    String uri = ApiConstance.baseUrl;
    switch(parameters.type){
      case 'pet':
        uri = uri + ApiConstance.addReport;
        break;
      case 'tool':
        uri = uri + ApiConstance.addToolReport;
        break;
      case 'food':
        uri = uri + ApiConstance.addReport;
        break;
    }
    final response = await http.post(
      Uri.parse(uri),
      headers: {
        'uid': uid,
        'x-auth-token': token,
        'itemID': parameters.itemID,
      },
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
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
  Future<List<FeedbackReportModel>> getFeedbackReports() async {
    String token = await getLocalData(key: "token");
    final response = await http.get(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.getFeedbackReports),
      headers: {'x-auth-token': token},
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);

      return List<FeedbackReportModel>.from(
        (res as List).map(
          (e) {
            return FeedbackReportModel.fromJson(e);
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
  Future<SuccessMessageModel> sendFeedbackReport(
      FeedbackReportParameters parameters) async {
    String token = await getLocalData(key: "token");
    final response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.sendFeedbackReport),
        headers: {'x-auth-token': token},
        body: {'content': parameters.content});
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
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
  Future<SuccessMessageModel> removeFeedbackReport(
      FeedbackReportParameters parameters) async {
    String token = await getLocalData(key: "token");
    final response = await http.delete(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.removeFeedbackReport),
        headers: {'x-auth-token': token},
        body: {'rid': parameters.reportId});
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
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
  Future<SuccessMessageModel> sendObjectionReport(
      ObjectionReportParameters parameters) async {
    final response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.sendObjectionReport),
        body: {
          'content': parameters.content,
          'email': parameters.email,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
          success: true);
    } else {
      if (response.statusCode != 401) {
        var res = await jsonDecode(response.body);
        throw ServerException(
            errorMessageModel: ErrorMessageModel(
                statusCode: response.statusCode,
                statusMessage: res.toString(),
                success: false));
      } else {
        throw ServerException(
            errorMessageModel: ErrorMessageModel(
                statusCode: response.statusCode,
                statusMessage: response.body.toString(),
                success: false));
      }
    }
  }

  @override
  Future<ObjectionReportModel> checkObjectionReport(
      ObjectionReportParameters parameters) async {
    final response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.checkObjectionReport),
        body: {'email': parameters.email});
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return ObjectionReportModel.fromJson(res);
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
  Future<List<ObjectionReportModel>> getObjectionReports() async {
    String token = await getLocalData(key: "token");
    final response = await http.get(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.getObjectionReports),
      headers: {'x-auth-token': token},
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<ObjectionReportModel>.from(
        (res as List).map(
          (e) {
            return ObjectionReportModel.fromJson(e);
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
  Future<ObjectionReportModel> answerOnObjectionReport(ObjectionReportModel parameters) async {
    String token = await getLocalData(key: "token");
    log(parameters.answer.toString());
    final response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.answerOnObjectionReports),
         headers: {'x-auth-token': token},
        body: {
          'id': parameters.id,
          'answer': parameters.answer,
        });
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      log(res.toString());
      return ObjectionReportModel.fromJson(res);
    } else {
        throw ServerException(
            errorMessageModel: ErrorMessageModel(
                statusCode: response.statusCode,
                statusMessage: response.body.toString(),
                success: false));
      }
  }
}
