import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/network/error_message_model.dart';
import 'package:pet_house/data/datasource/global/get_global_remote_data_source.dart';
import 'package:pet_house/data/models/foods/pet_foods_model.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/api_constant.dart';
import '../../../core/network/success_message_model.dart';
import '../../models/favourites/favourites_model.dart';
import '../../models/parameters/change_user_status_parameters.dart';
import '../../models/parameters/fav_parameters.dart';
import '../../models/parameters/no_parameters.dart';
import '../../models/parameters/search_parameters.dart';
import '../../models/parameters/user_parameters.dart';
import '../../models/parameters/user_pet_parameters.dart';

abstract class BaseUserDataRemoteDataSource {
  Future<UserModel> getUserData(NoParameters parameters);
  Future<List<FavouritesModel>> getFavourites(NoParameters parameters);
  Future<UserModel> signup(UserParameters parameters);
  Future<UserModel> signin(UserParameters parameters);
  Future<UserModel> updateUserData(UserParameters parameters);
  Future<List<FavouritesModel>> removeFavItem(FavParameters parameters);
  Future<UserModel> addFavItem(FavParameters parameters);
  Future<UserModel> getUserDataByID(UserParameters parameters);
  Future<SuccessMessageModel> removeUserItem(UserPetParameters parameters);
  Future<List<UserModel>> searchUsers(SearchParameters parameters);
  Future<SuccessMessageModel> changeUserStatusByManager(
      ChangeUserStatusByManagerParameters parameters);
  Future<List<UserModel>> getClosedAccounts(
      NoParameters parameters);    
}

class UserDataRemoteDataSource extends BaseUserDataRemoteDataSource {
  final globalRemoteDataSource = GlobalRemoteDataSource();

  @override
  Future<UserModel> getUserData(NoParameters parameters) async {
    String id = await getLocalData(key: "_id");
    String token = await getLocalData(key: "token");
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getUserData),
        headers: {
          'uid': id,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      //var userFav = [];
      //await getUserPets(res['favourites']);
      // res['favourites'] = userFav;
      var userPets = await getUserPets(res['myPets']);
      res['myPets'] = userPets;

      var userTools = await getUserTools(res['myPetTools']);
      res['myPetTools'] = userTools;

      var userFoods = await getUserFoods(res['myPetFoods']);
      res['myPetFoods'] = userFoods;

      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      setLocalData(key: '_id', val: res["_id"]);
      setLocalData(key: 'user', val: jsonEncode(res));
      setBoolLocalData(key: 'disable', val: false);
      return UserModel.fromjson(res);
    } else if (response.statusCode == 503) {
      setLocalData(key: 'token', val: '');
      setLocalData(key: '_id', val: '');
      setLocalData(key: 'user', val: '');
      setBoolLocalData(key: 'disable', val: true);
      setBoolLocalData(key: 'active', val: false);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
    else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }

  @override
  Future<UserModel> signin(UserParameters parameters) async {
    String token = await getLocalData(key: "token");
    var response = await http
        .post(Uri.parse(ApiConstance.baseUrl + ApiConstance.signin), body: {
      'email': parameters.email,
      'password': parameters.password,
    }, headers: {
      'x-auth-token': token
    });
    if (response.statusCode == 200) {
      setLocalData(key: "pass", val: parameters.password);
      var res = jsonDecode(response.body);
      //var userFav = await getUserPets(res['favourites']);
      var userPets = await getUserPets(res['myPets']);
      res['myPets'] = userPets;
      //res['favourites'] = userFav;
      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      setLocalData(key: '_id', val: res["_id"]);
      setLocalData(key: 'user', val: jsonEncode(res));
      setBoolLocalData(key: 'disable', val: false);
      return UserModel.fromjson(res);
    }
    else if (response.statusCode == 503) {
      setLocalData(key: 'token', val: '');
      setLocalData(key: '_id', val: '');
      setLocalData(key: 'user', val: '');
      setBoolLocalData(key: 'disable', val: true);
      setBoolLocalData(key: 'active', val: false);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
     else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }
  @override
  Future<UserModel> getUserDataByID(UserParameters parameters) async {
    String token = await getLocalData(key: "token");
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getUserDataByID),
        headers: {
          'uid': parameters.id,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
     // var userFav = await getUserPets(res['favourites']);
     // res['favourites'] = userFav;
      var userPets = await getUserPets(res['myPets']);
      res['myPets'] = userPets;
      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      return UserModel.fromjson(res);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }

  @override
  Future<UserModel> signup(UserParameters parameters) async {
    var response = await http.post(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.signup),
      body: {
        'email': parameters.email,
        'password': parameters.password,
        'name': parameters.name,
        'phone': parameters.phone,
        'picture': '',
        'address': '',
        'isAdmin': 'false',
        'isManager': 'false',
        // 'reports': [],
        // 'myPets': '[]',
        // 'myPetFoods': '[]',
        // 'myPetTools': '[]',
      },
    );
    if (response.statusCode == 200) {
      setLocalData(key: "pass", val: parameters.password);
      var res = jsonDecode(response.body);
     // var userFav = await getUserPets(res['favourites']);
      var userPets = await getUserPets(res['myPets']);
      res['myPets'] = userPets;
      //res['favourites'] = userFav;
      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      setLocalData(key: '_id', val: res["_id"]);
      setLocalData(key: 'user', val: jsonEncode(res));
      return UserModel.fromjson(res);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }

  @override
  Future<List<FavouritesModel>> removeFavItem(FavParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');

    var response = await http.delete(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.removeFavItem),
      headers: {'x-auth-token': token},
      body: {
        'uid': uid,
        'favID': parameters.id,
        'type': parameters.type,
      },
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      return List<FavouritesModel>.from(
        (res as List).map(
              (e) {
            return FavouritesModel.fromjson(e);
          },
        ),
      );
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }

  @override
  Future<UserModel> addFavItem(FavParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    var response = await http.post(
      Uri.parse(ApiConstance.baseUrl + ApiConstance.addFavItem),
      headers: {'x-auth-token': token},
      body: {
        'uid': uid,
        'favID': parameters.id,
        'type': parameters.type,
      },
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
       //var userFav = [];
      // //await getUserPets(res['favourites']);
      var userPets = await getUserPets(res['myPets']);
      res['myPets'] = userPets;
       //res['favourites'] = userFav;

      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      setLocalData(key: '_id', val: res["_id"]);
      setLocalData(key: 'user', val: jsonEncode(res));
      return UserModel.fromjson(res);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }

  @override
  Future<SuccessMessageModel> removeUserItem(UserPetParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    // final deleteResponse = await globalRemoteDataSource.deleteGlobalData(
    //     ApiConstance.baseUrl + ApiConstance.removePet,
    //     {"x-auth-token": token, 'pid': parameters.petID});
   // if (deleteResponse.statusCode == 200) {
      var response = await http.delete(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.removeUserItem),
        headers: {'x-auth-token': token},
        body: {
          'uid': uid,
          'pid': parameters.petID,
          'type': parameters.type,
        },
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        //var userFav = await getUserPets(res['favourites']);
        var userPets = await getUserPets(res['myPets']);
        res['myPets'] = userPets;
       // res['favourites'] = userFav;
        setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
        setLocalData(key: '_id', val: res["_id"]);
        //return UserModel.fromjson(res);
        return SuccessMessageModel(
            statusCode: response.statusCode,
            statusMessage: res['message'].toString(),
            success: true);
      }
      else {
        throw ServerException(
            errorMessageModel: ErrorMessageModel(
                statusCode: response.statusCode,
                statusMessage: response.body,
                success: false));
      }
   // }
   //    else {
   //    log('error ${deleteResponse.body}');
   //    throw ServerException(
   //        errorMessageModel: ErrorMessageModel(
   //            statusCode: deleteResponse.statusCode,
   //            statusMessage: 'error ${deleteResponse.body}',
   //            success: false));
   //  }
  }

  @override
  Future<UserModel> updateUserData(UserParameters parameters) async {
    String token = await getLocalData(key: "token");
    String uid = await getLocalData(key: '_id');
    // create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstance.baseUrl + ApiConstance.updateUserData),
    );
    // add file to request
    if (parameters.picture != null) {
      var fileStream = http.ByteStream(parameters.picture!.openRead());
      var fileLength = await parameters.picture!.length();
      var multipartFile = http.MultipartFile('file', fileStream, fileLength,
          filename: parameters.picture!.path.split('/').last);
      request.files.add(multipartFile);
    } else {
      request.fields['picture'] = '';
    }
    request.headers['x-auth-token'] = token;
    request.fields.addAll({
      'uid': uid,
      'name': parameters.name,
      'email': parameters.email,
      'phone': parameters.phone,
      'address': parameters.address,
      'password': parameters.password,
    });
    // send request and get response
    var response = await request.send();
    if (response.statusCode == 200) {
      setLocalData(key: "pass", val: parameters.password);
      var res = jsonDecode(await response.stream.bytesToString());
      //var userFav = await getUserPets(res['favourites']);
      var userPets = await getUserPets(res['myPets']);
      res['myPets'] = userPets;
     // res['favourites'] = userFav;
      setLocalData(key: 'token', val: response.headers['x-auth-token'] ?? "");
      setLocalData(key: '_id', val: res["_id"]);
      setLocalData(key: 'user', val: jsonEncode(res));
      return UserModel.fromjson(res);
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: jsonDecode(await response.stream.bytesToString()),
              success: false));
    }
  }

  void setLocalData({required String key, required String val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString(key, val);
  }

  void setBoolLocalData({required String key, required bool val}) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setBool(key, val);
  }

  Future<String> getLocalData({required String key}) async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }

  Future<List<PetModel>> getUserPets(List<dynamic> ides) async {
    List<PetModel> pets = [];
    if (ides.isNotEmpty) {
      for (var i in ides) {
        var response = await globalRemoteDataSource
            .getGlobalData("${ApiConstance.baseUrl}${ApiConstance.getPet}/$i");
        if (response.statusCode == 200) {
          pets.add(PetModel.fromJson(response.body));
        }
      }
    }
    return pets;
  }
  Future<List<PetToolModel>> getUserTools(List<dynamic> ides) async {
    List<PetToolModel> tools = [];
    if (ides.isNotEmpty) {
      for (var i in ides) {
        var response = await globalRemoteDataSource
            .getGlobalData("${ApiConstance.baseUrl}${ApiConstance.getToolById}/$i");

        if (response.statusCode == 200) {
          tools.add(PetToolModel.fromJson(response.body));
        }
      }
    }
    return tools;
  }
  Future<List<PetFoodsModel>> getUserFoods(List<dynamic> ides) async {
    List<PetFoodsModel> foods = [];
    if (ides.isNotEmpty) {
      for (var i in ides) {
        var response = await globalRemoteDataSource
            .getGlobalData("${ApiConstance.baseUrl}${ApiConstance.getFoodById}/$i");
        if (response.statusCode == 200) {
          foods.add(PetFoodsModel.fromJson(response.body));
        }
      }
    }
    return foods;
  }
  @override
  Future<List<UserModel>> searchUsers(SearchParameters parameters) async {
    String token = await getLocalData(key: "token");
    final response = await http.get(
      Uri.parse(
          ApiConstance.baseUrl + ApiConstance.searchUsers + parameters.text),
      headers: {'x-auth-token': token},
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<UserModel>.from(
        (res as List).map(
          (e) {
            return UserModel.fromjson(e);
          },
        ),
      );
    } else {
      log(response.body);
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }


  @override
  Future<SuccessMessageModel> changeUserStatusByManager(
      ChangeUserStatusByManagerParameters parameters) async {
    String token = await getLocalData(key: "token");
    var response = await http.post(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.changeUserStatus),
        headers: {'x-auth-token': token},
        body:
        //{'x':false.toString()}
        //json.encode(parameters)
        parameters.toMap()
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      return SuccessMessageModel(
          statusCode: response.statusCode,
          statusMessage: res['message'].toString(),
          success: true);
    } else {
      //var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body.toString(),
              success: false));
    }
  }
  
  @override
  Future<List<UserModel>> getClosedAccounts(NoParameters parameters)  async {
    String token = await getLocalData(key: "token");
    final response = await http.get(
      Uri.parse(
          ApiConstance.baseUrl + ApiConstance.getClosedAccounts),
      headers: {'x-auth-token': token},
    );
    if (response.statusCode == 200) {
      var res = await jsonDecode(response.body);
      return List<UserModel>.from(
        (res as List).map(
          (e) {
            return UserModel.fromjson(e);
          },
        ),
      );
    } else {
      log(response.body);
      var res = await jsonDecode(response.body);
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: res.toString(),
              success: false));
    }
  }

  @override
  Future<List<FavouritesModel>> getFavourites(NoParameters parameters) async {
    String id = await getLocalData(key: "_id");
    String token = await getLocalData(key: "token");
    final response = await http.get(
        Uri.parse(ApiConstance.baseUrl + ApiConstance.getFavourites),
        headers: {
          'uid': id,
          'x-auth-token': token,
        });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      return List<FavouritesModel>.from(
        (res as List).map(
              (e) {
            return FavouritesModel.fromjson(e);
          },
        ),
      );
    }
    else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode,
              statusMessage: response.body,
              success: false));
    }
  }
}
