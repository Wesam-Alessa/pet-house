import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/api_constant.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../../domain/entities/conversation/chat/create_chat.dart';
import '../../../domain/entities/conversation/chat/get_chat.dart';
import '../../../domain/entities/conversation/chat/initial_chat.dart';
import '../../../domain/entities/conversation/messaging/received_message.dart';
import '../../../domain/entities/conversation/messaging/send_message.dart';

abstract class BaseConversationsRemoteDataSource {
  Future<GetChatModel> accessChat(CreateChatModel parameters);
  Future<List<GetChatModel>> getChat();
  Future<ReceivedMessageModel> sendMessage(SendMessageModel parameters);
  Future<List<ReceivedMessageModel>> getMessages(InitialChatModel parameters);
}

class ConversationsRemoteDataSource extends BaseConversationsRemoteDataSource {
  void setLocalData({required String key, required String val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString(key, val);
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }

  @override
  Future<GetChatModel> accessChat(CreateChatModel parameters) async {
    String token = await getLocalData(key: "token");
    var response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.accessChat),
        body: {"userId": parameters.userId},
        headers: {"x-auth-token": token});
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      //log(response.headers['x-auth-token'].toString());
      //setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      //log(res.toString());
      return GetChatModel.fromJson(res);
    } else {
      var res = jsonDecode(response.body);
      //log(res.toString());
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res['errors'],
              success: false));
    }
  }

  @override
  Future<List<GetChatModel>> getChat() async {
    String token = await getLocalData(key: "token");
    var response =
        await http.get(Uri.parse(ApiConstance.baseUrl + ApiConstance.getChat),
            //body: {"userId":parameters.userId},
            headers: {"x-auth-token": token});
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      //log(response.headers['x-auth-token'].toString());
      //setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      //log(res.toString());
      return List<GetChatModel>.from(
        (res as List).map(
          (e) {
            return GetChatModel.fromJson(e);
          },
        ),
      );
      //return GetChatModel.fromJson(res);
    } else {
      var res = jsonDecode(response.body);
      log(res.toString());
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res['errors'],
              success: false));
    }
  }

  @override
  Future<List<ReceivedMessageModel>> getMessages(
      InitialChatModel parameters) async {
    String token = await getLocalData(key: "token");
    var response = await http.get(
      //url,
        Uri.parse(
            "${ApiConstance.baseUrl}${ApiConstance.getMessages}${parameters.id}?page=${parameters.offset}"),
        headers: {"x-auth-token": token});
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      return List<ReceivedMessageModel>.from(
        (res as List).map(
          (e) {
            return ReceivedMessageModel.fromJson(e);
          },
        ),
      );
    } else {
      var res = jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res['error'],
              success: false));
    }
  }

  @override
  Future<ReceivedMessageModel> sendMessage(SendMessageModel parameters) async {
    String token = await getLocalData(key: "token");
    var response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.sendMessage),
        headers: {
          "x-auth-token": token
        },
        body: {
          "content": parameters.content,
          "chatId": parameters.chatId,
          "receiver": parameters.receiver
        });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      //setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      //log(response.headers['x-auth-token'].toString());
      //log(res.toString());
      return ReceivedMessageModel.fromJson(res);
    } else {
      var res = jsonDecode(response.body);
      log(res.toString());
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res['errors'],
              success: false));
    }
  }
}
