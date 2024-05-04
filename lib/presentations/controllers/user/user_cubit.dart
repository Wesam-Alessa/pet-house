import 'dart:async';
import 'dart:developer';

import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/error/show_custom_snackbar.dart';
import 'package:pet_house/data/models/parameters/change_user_status_parameters.dart';
import 'package:pet_house/data/models/parameters/feedback_report_parameters.dart';
import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/data/models/parameters/objection_report_parameters.dart';
import 'package:pet_house/data/models/reports/feedback_report_model.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/entities/conversation/chat/create_chat.dart';
import 'package:pet_house/domain/entities/conversation/chat/get_chat.dart';
import 'package:pet_house/domain/entities/conversation/chat/initial_chat.dart';
import 'package:pet_house/domain/entities/conversation/messaging/send_message.dart';
import 'package:pet_house/domain/usecase/auth/signin_usecase.dart';
import 'package:pet_house/domain/usecase/auth/signup_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/access_chat_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/get_chat_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/get_messages_usecase.dart';
import 'package:pet_house/domain/usecase/conversations/send_message_usecase.dart';
import 'package:pet_house/domain/usecase/reports/add_report_usecase.dart';
import 'package:pet_house/domain/usecase/reports/answer_on_objection_report_usecase.dart';
import 'package:pet_house/domain/usecase/reports/delete_item_deletion_report_usecase.dart';
import 'package:pet_house/domain/usecase/reports/get_item_deletion_reports_usecase.dart';
import 'package:pet_house/domain/usecase/reports/get_objection_reports_usecase.dart';
import 'package:pet_house/domain/usecase/user/add_fav_item_usecase.dart';
import 'package:pet_house/domain/usecase/user/change_user_status_by-manager_usecase.dart';
import 'package:pet_house/domain/usecase/user/get_closed_accounts_usecase.dart';
import 'package:pet_house/domain/usecase/user/get_user_data_by_id_usecase.dart';
import 'package:pet_house/domain/usecase/user/get_user_data_usecase.dart';
import 'package:pet_house/domain/usecase/user/remove_fav_item_usecase.dart';
import 'package:pet_house/domain/usecase/user/remove_user_pet_usecase.dart';
import 'package:pet_house/domain/usecase/user/update_data_usecase.dart';
import 'package:pet_house/main.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/favourites/favourites_model.dart';
import '../../../data/models/parameters/fav_parameters.dart';
import '../../../data/models/parameters/no_parameters.dart';
import '../../../data/models/parameters/search_parameters.dart';
import '../../../data/models/parameters/user_parameters.dart';
import '../../../data/models/parameters/user_pet_parameters.dart';
import '../../../data/models/reports/item_deletion_report_model.dart';
import '../../../domain/entities/conversation/messaging/received_message.dart';
import '../../../domain/usecase/reports/check_objection_report_usecase.dart';
import '../../../domain/usecase/reports/get_feedback_report.dart';
import '../../../domain/usecase/reports/remove_feedback_report.dart';
import '../../../domain/usecase/reports/send_feedback_report.dart';
import '../../../domain/usecase/reports/send_objection_report_usecase.dart';
import '../../../domain/usecase/search/search_users_usecase.dart';
import '../../../domain/usecase/user/get_favourites.dart';

part 'user_state.dart';

bool isAdmin = false;
bool isManager = false;
List<ReceivedMessageModel> gmessages = [];

class UserCubit extends Cubit<UserState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final SharedPreferences sharedPreferences;
  final RemoveFavItemUseCase removeFavItemUseCase;
  final UpdateUserDataUseCase updateUserDataUseCase;
  final GetUserDataByIDUseCase getUserDataByIDUseCase;
  final RemoveUserPetUseCase removeUserPetUseCase;
  final AddFavItemUseCase addFavItemUseCase;
  final GetItemDeletionReportsUseCase getItemDeletionReportsUseCase;
  final DeleteItemDeletionReportUseCase deleteItemDeletionReportUseCase;
  final AddReportUseCase addReportUseCase;
  final AccessChatUsecase accessChatUsecase;
  final GetChatUsecase getChatUsecase;
  final SendMessagesUsecase sendMessagesUsecase;
  final GetMessagesUsecase getMessagesUsecase;
  final GetIFeedbackReportsUseCase getfeedbackReportsUseCase;
  final SendIFeedbackReportsUseCase sendIFeedbackReportsUseCase;
  final RemoveIFeedbackReportsUseCase removeIFeedbackReportsUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  final ChangeUserStatusByManagerUseCase changeUserStatusByManagerUseCase;
  final GetClosedAccountsUseCase getClosedAccountsUseCase;
  final SendObjectionReportUseCase sendObjectionReportUseCase;
  final CheckObjectionReportUseCase checkObjectionReportUseCase;
  final GetIObjectionReportsUseCase getIObjectionReportsUseCase;
  final AnswerOnobjectionReportUseCase answerOnobjectionReportUseCase;
  final GetFavouritesUseCase getFavouritesUseCase;
  UserCubit(
    this.signInUseCase,
    this.signUpUseCase,
    this.getUserDataUseCase,
    this.sharedPreferences,
    this.removeFavItemUseCase,
    this.updateUserDataUseCase,
    this.getUserDataByIDUseCase,
    this.removeUserPetUseCase,
    this.addFavItemUseCase,
    this.getItemDeletionReportsUseCase,
    this.deleteItemDeletionReportUseCase,
    this.addReportUseCase,
    this.accessChatUsecase,
    this.getChatUsecase,
    this.getMessagesUsecase,
    this.sendMessagesUsecase,
    this.getfeedbackReportsUseCase,
    this.sendIFeedbackReportsUseCase,
    this.removeIFeedbackReportsUseCase,
    this.searchUsersUseCase,
    this.changeUserStatusByManagerUseCase,
    this.getClosedAccountsUseCase,
    this.sendObjectionReportUseCase,
    this.checkObjectionReportUseCase,
    this.getIObjectionReportsUseCase,
    this.answerOnobjectionReportUseCase,
      this.getFavouritesUseCase,
  ) : super(UserInitial());

  List<String> _online = [];
  List<String> get online => _online;
  set onlineUsers(List<String> newList) {
    _online = newList;
    emit(state);
  }

  bool _typing = false;
  bool get typing => _typing;
  set typingState(bool newState) {
    _typing = newState;
    emit(state);
  }

  FutureOr<void> answerOnObjectionReport(BuildContext context,
      ObjectionReportModel model, List<ObjectionReportModel> list) async {
    try {
      emit(LoadingObjectionReportsState());
      final result = await answerOnobjectionReportUseCase(model);
      result.fold(
        (l) {
          emit(ErrorLoadingObjectionReportsState(failure: l));
          showError(context, l.message);
        },
        (r) {
          list.removeWhere((element) => element.id == r.id);
          list.add(r);
          emit(LoadedObjectionReportsState(reports: list));
        },
      );
    } on ServerException catch (e) {
      emit(const LoadedObjectionReportsState(reports: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getObjectionReports(BuildContext context) async {
    try {
      emit(LoadingObjectionReportsState());
      final result = await getIObjectionReportsUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(ErrorLoadingObjectionReportsState(failure: l));
          showError(context, l.message);
        },
        (r) {
          emit(LoadedObjectionReportsState(reports: r));
        },
      );
    } on ServerException catch (e) {
      emit(const LoadedObjectionReportsState(reports: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  Future<ObjectionReportModel?> checkObjectionReport(
      BuildContext context, String email) async {
    ObjectionReportModel? model;
    try {
      emit(LoadingObjectionReportState());
      final result = await checkObjectionReportUseCase(
          ObjectionReportParameters(content: '', email: email));
      result.fold(
        (l) {
          emit(ErrorLoadingObjectionReportState(failure: l));
          showError(context, l.message);
        },
        (r) {
          model = r;
          emit(LoadedObjectionReportState(report: r, exist: true));
        },
      );
      return model;
    } on ServerException catch (e) {
      log(e.errorMessageModel.statusCode.toString());
      if (e.errorMessageModel.statusCode == 404) {
        emit(const LoadedObjectionReportState(report: null, exist: false));
        model = ObjectionReportModel(
            id: '',
            email: email,
            content: '',
            answer: '',
            date: DateTime.now(),
            responseDate: DateTime.now());
      } else {
        emit(ErrorLoadingObjectionReportState(
            failure: ServerFailure(e.errorMessageModel.statusMessage)));
        showError(context, e.errorMessageModel.statusMessage);
      }
      return model;
    }
  }

  FutureOr<void> sendObjectionReport(
      BuildContext context, String content, String email) async {
    try {
      final result = await sendObjectionReportUseCase(
          ObjectionReportParameters(content: content, email: email));
      result.fold(
        (l) {
          showError(context, l.message);
        },
        (r) {
          showSuccess(context, r.statusMessage);
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getClosedAccounts(
    BuildContext context,
  ) async {
    try {
      emit(LoadingClosedAccountsListState());
      final result = await getClosedAccountsUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(ErrorClosedAccountsListState(failure: l));
          showError(context, l.message);
        },
        (r) {
          emit(LoadedClosedAccountsListState(list: r));
        },
      );
    } on ServerException catch (e) {
      emit(const LoadedClosedAccountsListState(list: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> reActiveClosedAccount(BuildContext context,
      List<UserModel> list, String uid, UserModel user) async {
    try {
      emit(LoadingClosedAccountsListState());
      final result = await changeUserStatusByManagerUseCase(
          ChangeUserStatusByManagerParameters(
              disabled: false,
              isAdmin: user.isAdmin,
              isManager: user.isManager,
              whyDisabled: '',
              uid: uid));
      result.fold(
        (l) {
          emit(LoadedClosedAccountsListState(list: list));
          showError(context, l.message);
        },
        (r) {
          list.removeWhere((e) => uid == e.id);
          emit(LoadedClosedAccountsListState(list: list));
          showSuccess(context, r.statusMessage);
        },
      );
    } on ServerException catch (e) {
      emit(LoadedClosedAccountsListState(list: list));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> changeUserStatusByManager(BuildContext context,
      ChangeUserStatusByManagerParameters parameters) async {
    try {
      //emit(LoadingReport());
      final result = await changeUserStatusByManagerUseCase(parameters);
      result.fold(
        (l) {
          showError(context, l.message);
        },
        (r) {
          showSuccess(context, r.statusMessage);
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void searchUsers(
      {required BuildContext context, required String text}) async {
    try {
      emit(LoadingSearchUsersState());
      //String searchKey = text[0].toLowerCase() + text.substring(1);
      final result = await searchUsersUseCase(SearchParameters(text: text));
      result.fold(
        (l) {
          emit(ErrorSearchUsersState(failure: l));
        },
        (r) {
          emit(LoadedSearchUsersState(search: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorSearchUsersState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void clearSearchUsers() {
    emit(const LoadedSearchUsersState(search: []));
  }

  FutureOr<void> getFeedbackReports(BuildContext context) async {
    try {
      emit(LoadingFeedbackReportsState());
      final result = await getfeedbackReportsUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(const LoadedFeedbackReportsState(
            reports: [],
          ));
        },
        (r) {
          emit(LoadedFeedbackReportsState(
            reports: r,
          ));
        },
      );
    } on ServerException catch (e) {
      emit(const LoadedFeedbackReportsState(
        reports: [],
      ));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> sendfeedbackReport(
      BuildContext context, String content) async {
    try {
      emit(LoadingFeedbackReportsState());
      final result = await sendIFeedbackReportsUseCase(
          FeedbackReportParameters(content: content, reportId: ''));
      result.fold(
        (l) {
          emit(const LoadedFeedbackReportsState(
            reports: [],
          ));
          showError(context, l.message);
        },
        (r) {
          emit(const LoadedFeedbackReportsState(reports: []));
          showSuccess(context, r.statusMessage);
        },
      );
    } on ServerException catch (e) {
      emit(const LoadedFeedbackReportsState(reports: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> removefeedbackReport(BuildContext context,
      List<FeedbackReportModel> reports, String rid) async {
    try {
      emit(LoadingFeedbackReportsState());
      final result = await removeIFeedbackReportsUseCase(
          FeedbackReportParameters(content: '', reportId: rid));
      result.fold(
        (l) {
          emit(LoadedFeedbackReportsState(
            reports: reports,
          ));
          showError(context, l.message);
        },
        (r) {
          reports.removeWhere((e) => rid == e.id);
          emit(LoadedFeedbackReportsState(reports: reports));
          showSuccess(context, r.statusMessage);
        },
      );
    } on ServerException catch (e) {
      emit(LoadedFeedbackReportsState(reports: reports));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  Future<Either<Failure, ReceivedMessageModel>> sendMessage(
      BuildContext context, SendMessageModel model) async {
    final result = await sendMessagesUsecase(model);
    return result;
  }

  FutureOr<void> getMessages(
      BuildContext context, String chatId, int offset) async {
    try {
      emit(LoadingMessageState());
      final result = await getMessagesUsecase(
          InitialChatModel(id: chatId, offset: offset));
      result.fold(
        (l) {
          emit(ErrorLoadingMessageState(failure: l));
          showError(context, l.message);
        },
        (r) {
          if (offset == 1) {
            gmessages.clear();
          }
          gmessages.addAll(r);
          emit(LoadedMessageState(messages: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingMessageState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getChats(BuildContext context) async {
    try {
      emit(LoadingChatsState());
      final result = await getChatUsecase(const NoParameters());
      result.fold(
        (l) {
          emit(ErrorLoadingChatsState(failure: l));
          showError(context, l.message);
        },
        (r) {
          emit(LoadedChatsState(chats: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingChatsState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> accessChat(BuildContext context, String userId) async {
    try {
      emit(LoadingAccessChatState());
      //showWaitnig(context, 'Waiting ...');
      final result = await accessChatUsecase(CreateChatModel(userId: userId));
      result.fold(
        (l) {
          emit(ErrorLoadingChatsState(failure: l));
          showError(context,
              'An error occurred when creating a conversation with this seller, try again');
        },
        (r) {
          emit(LoadedAccessChatState(chat: r));
          Navigator.pushNamed(context, CHAT_SCREEN);
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingAccessChatState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addReportToItem(BuildContext context, String itemID,String type) async {
    try {
      //emit(LoadingReport());
      final result =
          await addReportUseCase(AddReportParameters(itemID: itemID,type:type));
      result.fold(
        (l) {
          // emit(ErrorLoadingReport());
          showError(context, l.message);
        },
        (r) {
          //emit(LoadedReport());
          showSuccess(context, r.statusMessage);
        },
      );
    } on ServerException catch (e) {
      //emit(ErrorLoadingReport());
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> deleteItemDeletionReport(
      BuildContext context,
      DeleteItemDeletionReportParameters parameters,
      List<ItemDeletionReportModel> reports) async {
    try {
      emit(LoadingItemDeletionReports());
      final result = await deleteItemDeletionReportUseCase(parameters);
      result.fold(
        (l) {
          emit(LoadedItemDeletionReports(
            reports: reports,
          ));
        },
        (r) {
          reports.removeWhere(
              (element) => element.reportID == parameters.reportID);
          showSuccess(context, r.statusMessage);
          emit(LoadedItemDeletionReports(
            reports: reports,
          ));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedItemDeletionReports(reports: reports));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getItemDeletionReports(BuildContext context) async {
    try {
      emit(LoadingItemDeletionReports());
      final result = await getItemDeletionReportsUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(const LoadedItemDeletionReports(
            reports: [],
          ));
        },
        (r) {
          emit(LoadedItemDeletionReports(
            reports: r,
          ));
        },
      );
    } on ServerException catch (e) {
      emit(const LoadedItemDeletionReports(
        reports: [],
      ));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getUserData(BuildContext context) async {
    try {
      emit(LoadingUserData());
      final result = await getUserDataUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(ErrorLoadingUserData(failure: l));
        },
        (r) {
          isAdmin = r.isAdmin;
          isManager = r.isManager;
          emit(LoadedUserData(userModel: r, ownerPet: null));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingUserData(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
      if (e.errorMessageModel.statusCode == 503 ||
          e.errorMessageModel.statusCode == 401) {
        Navigator.pushReplacementNamed(context, SIGNIN_SCREEN);
      }
    }
  }

  FutureOr<void> getUserDataByID(
      BuildContext context, UserModel user, String uid) async {
    try {
      emit(LoadingUserData());
      final result = await getUserDataByIDUseCase(UserParameters(
          id: uid,
          address: '',
          email: '',
          name: '',
          password: '',
          phone: '',
          picture: null,
          isAdmin: false));
      result.fold(
        (l) {
          showError(context, "This user not Found !!");
          emit(LoadedUserData(userModel: user, ownerPet: null));
        },
        (r) {
          emit(LoadedUserData(userModel: user, ownerPet: r));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedUserData(userModel: user, ownerPet: null));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> signin(
      BuildContext context, String email, String password) async {
    try {
      emit(LoadingUserData());
      final result = await signInUseCase(UserParameters(
          id: '',
          email: email,
          password: password,
          name: '',
          phone: '',
          address: "",
          isAdmin: false));
      result.fold(
        (l) {
          emit(ErrorLoadingUserData(failure: l));
        },
        (r) {
          log("USER CUBIT ISADMIN := ${r.isAdmin}");
          log("USER CUBIT ISMANAGER := ${r.isManager}");
          isAdmin = r.isAdmin;
          isManager = r.isManager;
          emit(LoadedUserData(userModel: r, ownerPet: null));
          setActiveSharedValue(true);
          Navigator.pushReplacementNamed(context, HOME_SCREEN);
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingUserData(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
      if (e.errorMessageModel.statusCode == 503 ||
          e.errorMessageModel.statusCode == 401) {
        Navigator.pushReplacementNamed(context, SIGNIN_SCREEN);
      }
    }
  }

  FutureOr<void> signup(BuildContext context, String name, String email,
      String password, String phone) async {
    try {
      emit(LoadingUserData());
      final result = await signUpUseCase(UserParameters(
          id: '',
          email: email,
          password: password,
          name: name,
          phone: phone,
          address: "",
          isAdmin: false));
      result.fold(
        (l) {
          emit(ErrorLoadingUserData(failure: l));
        },
        (r) {
          log("USER CUBIT ISADMIN := ${r.isAdmin}");
          isAdmin = r.isAdmin;
          isManager = r.isManager;
          emit(LoadedUserData(userModel: r, ownerPet: null));
          setActiveSharedValue(true);
          Navigator.pushReplacementNamed(context, HOME_SCREEN);
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingUserData(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> removeFavItem(BuildContext context, String favid,String type) async {
    try {
      emit(LoadingFavouritesState());
      final result =
          await removeFavItemUseCase(FavParameters(id: favid,type: type,));
      result.fold(
        (l) {
          emit(ErrorLoadingFavouritesState(failure: l));
        },
        (r) {
          emit(LoadedFavouritesState(items: r ));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingFavouritesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));

      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addFavItem(BuildContext context, String favid,String type) async {
    try {
      emit(LoadingUserData());
      final result = await addFavItemUseCase(FavParameters(id: favid,type: type,));
      result.fold(
        (l) {
          emit(ErrorLoadingUserData(failure: l));
          showError(context, "failed");
        },
        (r) {
          emit(LoadedUserData(userModel: r, ownerPet: null));
          showSuccess(context, "Added successfully");
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingUserData(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> removeUserItem(
      BuildContext context, String petID,String type, UserModel user) async {
    try {
      emit(LoadingUserData());
      final result =
          await removeUserPetUseCase(UserPetParameters(petID: petID,type:type ));
      result.fold(
        (l) {
          emit(LoadedUserData(userModel: user, ownerPet: null));
          showError(context, 'ERROR : ${l.message}');
        },
        (r) {
          switch(type){
            case 'pet':
              int index = user.myPets.indexWhere((e) => petID == e.id);
              user.myPets = user.myPets.removeAt(index);
              break;
            case 'tool':
              int index = user.myTools.indexWhere((e) => petID == e.id);
              user.myTools.removeAt(index);
              break;
            case 'food':
              int index = user.myFoods.indexWhere((e) => petID == e.id);
              user.myFoods = user.myFoods.removeAt(index);
              break;
          }
          emit(LoadedUserData(userModel: user, ownerPet: null));
          showSuccess(context, 'success');
        },
      );
    } on ServerException catch (e) {
      emit(LoadedUserData(userModel: user, ownerPet: null));
      showError(context, 'ERROR : ${e.errorMessageModel.statusMessage}');
    }
  }

  FutureOr<void> getFavourites(BuildContext context) async {
    try {
      emit(LoadingFavouritesState());
      final result = await getFavouritesUseCase(const NoParameters());
      result.fold(
            (l) {
          emit(ErrorLoadingFavouritesState(failure: l));
          showError(context, l.message);
        },
            (r) {
          emit(LoadedFavouritesState(items: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingFavouritesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> updateUserData(
      BuildContext context, UserParameters parameters) async {
    try {
      emit(LoadingUserData());
      final result = await updateUserDataUseCase(parameters);
      result.fold(
        (l) {
          emit(ErrorLoadingUserData(failure: l));
        },
        (r) {
          emit(LoadedUserData(userModel: r, ownerPet: null));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorLoadingUserData(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void signout(BuildContext context) {
    setActiveSharedValue(false);
    Navigator.pushReplacementNamed(context, SIGNIN_SCREEN);
  }

  Future<void> setActiveSharedValue(bool val) async {
    await sharedPreferences.setBool('active', val);
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }

  showSuccess(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.successSnackBar(message));
  }

  showWaitnig(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.waitingSnackBar(message));
  }
}
