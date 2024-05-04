import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/data/datasource/categories/pet_categories_remote_data_source.dart';
import 'package:pet_house/data/datasource/conversations/conversations_remote_data_source.dart';
import 'package:pet_house/data/datasource/reports/reports_remote_data_source.dart';
import 'package:pet_house/data/datasource/splash/splash_remote_data_source.dart';
import 'package:pet_house/data/datasource/user/user_data_remote_data_source.dart';
import 'package:pet_house/data/repository/categories/pet_category_repository.dart';
import 'package:pet_house/data/repository/conversations/conversations_repository.dart';
import 'package:pet_house/data/repository/reports/reports_reporistory.dart';
import 'package:pet_house/data/repository/splash/splash_repository.dart';
import 'package:pet_house/data/repository/user/user_data_repository.dart';
import 'package:pet_house/domain/repository/categories/base_pet_category_repository.dart';
import 'package:pet_house/domain/repository/conversations/base_conversation_repository.dart';
import 'package:pet_house/domain/repository/intellectual_property_rights/base_intellectual_property_rights_repository.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:pet_house/domain/repository/reports/base_reports_repository.dart';
import 'package:pet_house/domain/repository/splash/base_splash_repository.dart';
import 'package:pet_house/domain/repository/user/base_user_data_repository.dart';
import 'package:pet_house/domain/usecase/auth/signin_usecase.dart';
import 'package:pet_house/domain/usecase/auth/signup_usecase.dart';
import 'package:pet_house/domain/usecase/categories/pets/update_pet_category_usecase.dart';
import 'package:pet_house/domain/usecase/categories/tools/add_new_tools_category_usecase.dart';
import 'package:pet_house/domain/usecase/categories/tools/get_tools_category_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/access_chat_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/get_chat_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/get_messages_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/send_message_usecase.dart';
import 'package:pet_house/domain/usecase/pet/add_new_pet_usecase.dart';
import 'package:pet_house/domain/usecase/categories/pets/get_pet_categories_usecase.dart';
import 'package:pet_house/domain/usecase/pet/get_pet_usecase.dart';
import 'package:pet_house/domain/usecase/pet/reported_pets/get_reported_pets_usecase.dart';
import 'package:pet_house/domain/usecase/pet/waiting_pets/publish_waiting_pet_usecase.dart';
import 'package:pet_house/domain/usecase/reports/answer_on_objection_report_usecase.dart';
import 'package:pet_house/domain/usecase/reports/get_item_deletion_reports_usecase.dart';
import 'package:pet_house/domain/usecase/reports/get_objection_reports_usecase.dart';
import 'package:pet_house/domain/usecase/reports/post_item_deletion_report_usecase.dart';
import 'package:pet_house/domain/usecase/search/search_usecase.dart';
import 'package:pet_house/domain/usecase/splash/get_splash_usecase.dart';
import 'package:pet_house/domain/usecase/user/get_closed_accounts_usecase.dart';
import 'package:pet_house/domain/usecase/user/get_user_data_usecase.dart';
import 'package:pet_house/domain/usecase/user/remove_fav_item_usecase.dart';
import 'package:pet_house/domain/usecase/user/remove_user_pet_usecase.dart';
import 'package:pet_house/domain/usecase/user/update_data_usecase.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:pet_house/presentations/controllers/tools/tools_cubit.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasource/categories/foods_categories_remote_data_source.dart';
import '../../data/datasource/categories/tools_categories_remote_data_source.dart';
import '../../data/datasource/foods/foods_remote_data_source.dart';
import '../../data/datasource/intellectual_property_rights/intellectual_property_rights_remote_data_source.dart';
import '../../data/datasource/pet/pet_remote_data_source.dart';
import '../../data/datasource/tools/tools_remote_data_source.dart';
import '../../data/repository/categories/pet_foods_category_repository.dart';
import '../../data/repository/categories/tools_category_repository.dart';
import '../../data/repository/foods/foods_repository.dart';
import '../../data/repository/intellectual_property_rights/intellectual_property_rights_repository.dart';
import '../../data/repository/pet/pet_repository.dart';
import '../../data/repository/tools/tools_repository.dart';
import '../../domain/repository/categories/base_pet_foods_category_repository.dart';
import '../../domain/repository/categories/base_tools_category_repository.dart';
import '../../domain/repository/foods/base_foods_repository.dart';
import '../../domain/repository/tools/base_tools_repository.dart';
import '../../domain/usecase/categories/foods/add_new_foods_category_usecase.dart';
import '../../domain/usecase/categories/foods/get_foods_category_usecase.dart';
import '../../domain/usecase/categories/foods/update_foods_category_usecase.dart';
import '../../domain/usecase/categories/pets/add_new_pet_category_usecase.dart';
import '../../domain/usecase/categories/tools/update_tools_category_usecase.dart';
import '../../domain/usecase/foods/add_new_food_usecase.dart';
import '../../domain/usecase/foods/foods_search/foods_search_usecase.dart';
import '../../domain/usecase/foods/get_foods_usecase.dart';
import '../../domain/usecase/foods/reported_foods/get_reported_foods_usecase.dart';
import '../../domain/usecase/foods/reported_foods/remove_food_reports_usecase.dart';
import '../../domain/usecase/foods/waiting_foods/get_waiting_foods_usecase.dart';
import '../../domain/usecase/foods/waiting_foods/publish_waiting_food_usecase.dart';
import '../../domain/usecase/intellectual_property_rights/get_intellectual_property_rights_usecase.dart';
import '../../domain/usecase/intellectual_property_rights/update_intellectual_property_rights_usecase.dart';
import '../../domain/usecase/pet/reported_pets/remove_pet_reports_usecase.dart';
import '../../domain/usecase/pet/waiting_pets/get_waiting_pets_usecase.dart';
import '../../domain/usecase/reports/add_report_usecase.dart';
import '../../domain/usecase/reports/check_objection_report_usecase.dart';
import '../../domain/usecase/reports/delete_item_deletion_report_usecase.dart';
import '../../domain/usecase/reports/get_feedback_report.dart';
import '../../domain/usecase/reports/remove_feedback_report.dart';
import '../../domain/usecase/reports/send_feedback_report.dart';
import '../../domain/usecase/reports/send_objection_report_usecase.dart';
import '../../domain/usecase/search/search_users_usecase.dart';
import '../../domain/usecase/tools/add_new_tool_usecase.dart';
import '../../domain/usecase/tools/get_tools_usecase.dart';
import '../../domain/usecase/tools/reported_tools/get_reported_tools_usecase.dart';
import '../../domain/usecase/tools/reported_tools/remove_tool_reports_usecase.dart';
import '../../domain/usecase/tools/tools_search/tools_search_usecase.dart';
import '../../domain/usecase/tools/waiting_tools/get_waiting_tools_usecase.dart';
import '../../domain/usecase/tools/waiting_tools/publish_waiting_tool_usecase.dart';
import '../../domain/usecase/user/add_fav_item_usecase.dart';
import '../../domain/usecase/user/change_user_status_by-manager_usecase.dart';
import '../../domain/usecase/user/get_favourites.dart';
import '../../domain/usecase/user/get_user_data_by_id_usecase.dart';
import '../../presentations/controllers/App/app_cubit.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../presentations/controllers/pet_foods/pet_foods_cubit.dart';
import '../constant/api_constant.dart';

final getIt = GetIt.instance;
final UserCubit globalUserCubit = getIt();
final PetCubit globalPetCubit = getIt();
final ToolsCubit globalToolsCubit = getIt();
final PetFoodsCubit globalPetFoodsCubit = getIt();
final AppCubit globalAppCubit = getIt();
final IO.Socket gsocket = getIt();
late bool isDarkTheme;
final FlutterLocalization localization = FlutterLocalization.instance;
late String initLanguageCode;

class ServicesLocator {
  Future<void> init() async {
    //sharedPreferences.setString('token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDNiZTg4MWQyMDBiNzIyOGYyMzQxODYiLCJpc0FkbWluIjp0cnVlLCJpYXQiOjE2ODk1MTY3OTR9.diRxAc99OkDnfghUhNgxVaHmFYwuZbR_JuNdsscCOPk');
    final sharedPreferences = await SharedPreferences.getInstance();
    //isDarkTheme = true;
    isDarkTheme = sharedPreferences.getBool('isDarkTheme') ?? false;
    List<dynamic> activeUsers = [];
    IO.Socket socket;
    String user = sharedPreferences.getString('user') ?? '';
    String uid = user != '' ? jsonDecode(user)['_id'] : "";
    socket = IO.io(ApiConstance.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.emit('setup', uid);
    socket.connect();
    socket.onConnect((_) {
      log('Connect to front end Services Locator');
      socket.on('online-user', (activeUsersApi) {
        activeUsers = activeUsersApi;
        log('online-user Services Locator => $activeUsersApi');
      });
      socket.on('re-connect-user', (activeUsersApi) {
        activeUsers = activeUsersApi;
        log('re-connect-user Services Locator => $activeUsersApi');
      });
    });

    /// VARS
    getIt.registerFactory(() => sharedPreferences);
    getIt.registerFactory(() => activeUsers);
    getIt.registerFactory(() => socket);

    ///BLOC
    getIt.registerFactory(() => PetCubit(getIt(), getIt(), getIt(), getIt(),
        getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => AppCubit(getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => UserCubit(
        getIt(),getIt(),getIt(),getIt(),getIt(),
        getIt(),getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt()));
    getIt.registerFactory(() => ToolsCubit(getIt(),getIt(),getIt(),getIt(),getIt(),getIt(),getIt(),getIt(),getIt(), getIt(), getIt(),));
    getIt.registerFactory(() => PetFoodsCubit(getIt(),getIt(),getIt(),getIt(),getIt(),getIt(),getIt(),getIt(),getIt(), getIt(), getIt(),));



    ///USER CASEs
    getIt.registerLazySingleton(() => GetPetUseCase(getIt()));
    getIt.registerLazySingleton(() => GetWaitingPetsUseCase(getIt()));
    getIt.registerLazySingleton(() => PublishWaitingPetUseCase(getIt()));
    getIt.registerLazySingleton(() => GetPetCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(() => AddNewPetCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(() => GetSplasUseCase(getIt()));
    getIt.registerLazySingleton(() => GetUserDataUseCase(getIt()));
    getIt.registerLazySingleton(() => GetUserDataByIDUseCase(getIt()));
    getIt.registerLazySingleton(() => SignInUseCase(getIt()));
    getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
    getIt.registerLazySingleton(() => RemoveFavItemUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdateUserDataUseCase(getIt()));
    getIt.registerLazySingleton(() => AddNewPetUseCase(getIt()));
    getIt.registerLazySingleton(() => RemoveUserPetUseCase(getIt()));
    getIt.registerLazySingleton(() => AddFavItemUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdatePetCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(
        () => GetIntellectualPropertyRightsUseCase(getIt()));
    getIt.registerLazySingleton(
        () => UpdateIntellectualPropertyRightsUseCase(getIt()));
    getIt.registerLazySingleton(() => PostItemDeletionReportUseCase(getIt()));
    getIt.registerLazySingleton(() => GetPetsReportedUseCase(getIt()));
    getIt.registerLazySingleton(() => RemovePetReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => GetItemDeletionReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => DeleteItemDeletionReportUseCase(getIt()));
    getIt.registerLazySingleton(() => AddReportUseCase(getIt()));
    getIt.registerLazySingleton(() => SearchUseCase(getIt()));
    getIt.registerLazySingleton(() => AccessChatUsecase(getIt()));
    getIt.registerLazySingleton(() => GetChatUsecase(getIt()));
    getIt.registerLazySingleton(() => SendMessagesUsecase(getIt()));
    getIt.registerLazySingleton(() => GetMessagesUsecase(getIt()));
    getIt.registerLazySingleton(() => GetIFeedbackReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => SendIFeedbackReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => RemoveIFeedbackReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => SearchUsersUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangeUserStatusByManagerUseCase(getIt()));
    getIt.registerLazySingleton(() => GetClosedAccountsUseCase(getIt()));
    getIt.registerLazySingleton(() => SendObjectionReportUseCase(getIt()));
    getIt.registerLazySingleton(() => CheckObjectionReportUseCase(getIt()));
    getIt.registerLazySingleton(() => GetIObjectionReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => AnswerOnobjectionReportUseCase(getIt()));
    getIt.registerLazySingleton(() => GetToolsCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(() => AddNewToolsCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdateToolsCategoryUseCase(getIt()));
    getIt.registerLazySingleton(() => GetPetFoodsCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(() => AddNewPetFoodsCategoriesUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdatePetFoodsCategoryUseCase(getIt()));
    getIt.registerLazySingleton(() => GetFavouritesUseCase(getIt()));


    ///TOOLS USE CASE
    getIt.registerLazySingleton(() => GetToolsReportedUseCase(getIt()));
    getIt.registerLazySingleton(() => RemoveToolReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => ToolsSearchUseCase(getIt()));
    getIt.registerLazySingleton(() => GetWaitingToolsUseCase(getIt()));
    getIt.registerLazySingleton(() => PublishWaitingToolUseCase(getIt()));
    getIt.registerLazySingleton(() => AddNewToolUseCase(getIt()));
    getIt.registerLazySingleton(() => GetToolsUseCase(getIt()));

    ///FOODS USE CASE
    getIt.registerLazySingleton(() => GetFoodsReportedUseCase(getIt()));
    getIt.registerLazySingleton(() => RemoveFoodReportsUseCase(getIt()));
    getIt.registerLazySingleton(() => FoodsSearchUseCase(getIt()));
    getIt.registerLazySingleton(() => GetWaitingFoodsUseCase(getIt()));
    getIt.registerLazySingleton(() => PublishWaitingFoodUseCase(getIt()));
    getIt.registerLazySingleton(() => AddNewFoodUseCase(getIt()));
    getIt.registerLazySingleton(() => GetFoodsUseCase(getIt()));

    /// REPOSITORY
    getIt
        .registerLazySingleton<BasePetRepository>(() => PetRepository(getIt()));
    getIt.registerLazySingleton<BasePetCategoriesRepository>(
        () => PetCategoriesRepository(getIt()));
    getIt.registerLazySingleton<BaseToolsCategoriesRepository>(
            () => ToolCategoriesRepository(getIt()));
    getIt.registerLazySingleton<BasePetFoodsCategoriesRepository>(
            () => PetFoodsCategoriesRepository(getIt()));
    getIt.registerLazySingleton<BaseSplashRepository>(
        () => SplashRepository(getIt()));
    getIt.registerLazySingleton<BaseUserDataRepository>(
        () => UserDataRepository(getIt()));
    getIt.registerLazySingleton<BaseIntellectualPropertyRightsRepository>(
        () => IntellectualPropertyRightsRepository(getIt()));
    getIt.registerLazySingleton<BaseReportsRepository>(
        () => ReportsRepository(getIt()));
    getIt.registerLazySingleton<BaseConversationRepository>(
        () => ConversationsRepository(getIt()));
    getIt.registerLazySingleton<BaseToolsRepository>(
            () => ToolsRepository(getIt()));
    getIt.registerLazySingleton<BaseFoodsRepository>(
            () => FoodsRepository(getIt()));

    ///DATA SOURCE
    getIt.registerLazySingleton<BasePetRemoteDataSource>(
        () => PetRemoteDataSource());
    getIt.registerLazySingleton<BasePetCategoriesRemoteDataSource>(
        () => PetCategoriesRemoteDataSource());
    getIt.registerLazySingleton<BaseToolsCategoriesRemoteDataSource>(
            () => ToolsCategoriesRemoteDataSource());
    getIt.registerLazySingleton<BasePetFoodsCategoriesRemoteDataSource>(
            () => PetFoodsCategoriesRemoteDataSource());
    getIt.registerLazySingleton<BaseSplashRemoteDataSource>(
        () => SplashRemoteDataSource());
    getIt.registerLazySingleton<BaseUserDataRemoteDataSource>(
        () => UserDataRemoteDataSource());
    getIt.registerLazySingleton<BaseIntellectualPropertyRightsRemoteDataSource>(
        () => IntellectualPropertyRightsRemoteDataSource());
    getIt.registerLazySingleton<BaseReportsRemoteDataSource>(
        () => ReportsRemoteDataSource());
    getIt.registerLazySingleton<BaseConversationsRemoteDataSource>(
        () => ConversationsRemoteDataSource());
    getIt.registerLazySingleton<BaseToolsRemoteDataSource>(
            () => ToolsRemoteDataSource());
    getIt.registerLazySingleton<BaseFoodsRemoteDataSource>(
            () => FoodsRemoteDataSource());
  }
}
