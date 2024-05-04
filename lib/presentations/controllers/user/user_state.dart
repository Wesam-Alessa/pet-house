part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class LoadingUserData extends UserState {}

class LoadedUserData extends UserState {
  final UserModel userModel;
  final UserModel? ownerPet;
  const LoadedUserData({required this.userModel, this.ownerPet});
}

class ErrorLoadingUserData extends UserState {
  final Failure failure;
  const ErrorLoadingUserData({required this.failure});
}

class LoadingItemDeletionReports extends UserState {}

class LoadedItemDeletionReports extends UserState {
  final List<ItemDeletionReportModel> reports;
  const LoadedItemDeletionReports({required this.reports});
}

class ErrorLoadingItemDeletionReports extends UserState {
  final Failure failure;
  const ErrorLoadingItemDeletionReports({required this.failure});
}

class LoadingReport extends UserState {}

class LoadedReport extends UserState {}

class ErrorLoadingReport extends UserState {}

class LoadingAccessChatState extends UserState {}

class LoadedAccessChatState extends UserState {
  final GetChatModel chat;
  const LoadedAccessChatState({required this.chat});
}

class ErrorLoadingAccessChatState extends UserState {
  final Failure failure;
  const ErrorLoadingAccessChatState({required this.failure});
}

class LoadingChatsState extends UserState {}

class LoadedChatsState extends UserState {
  final List<GetChatModel> chats;
  const LoadedChatsState({required this.chats});
}

class ErrorLoadingChatsState extends UserState {
  final Failure failure;
  const ErrorLoadingChatsState({required this.failure});
}

class LoadingMessageState extends UserState {}

class LoadedMessageState extends UserState {
  final List<ReceivedMessageModel> messages;
  const LoadedMessageState({required this.messages});
}

class ErrorLoadingMessageState extends UserState {
  final Failure failure;
  const ErrorLoadingMessageState({required this.failure});
}

class LoadingFeedbackReportsState extends UserState {}

class LoadedFeedbackReportsState extends UserState {
  final List<FeedbackReportModel> reports;
  const LoadedFeedbackReportsState({required this.reports});
}

class ErrorLoadingFeedbackReportsState extends UserState {
  final Failure failure;
  const ErrorLoadingFeedbackReportsState({required this.failure});
}

class LoadingSearchUsersState extends UserState {}

class LoadedSearchUsersState extends UserState {
  final List<UserModel> search;
  const LoadedSearchUsersState({required this.search});
}

class ErrorSearchUsersState extends UserState {
  final Failure failure;
  const ErrorSearchUsersState({required this.failure});
}

class LoadingClosedAccountsListState extends UserState {}

class LoadedClosedAccountsListState extends UserState {
  final List<UserModel> list;
  const LoadedClosedAccountsListState({required this.list});
}

class ErrorClosedAccountsListState extends UserState {
  final Failure failure;
  const ErrorClosedAccountsListState({required this.failure});
}

class LoadingObjectionReportState extends UserState {}

class LoadedObjectionReportState extends UserState {
  final ObjectionReportModel? report;
  final bool exist;
  const LoadedObjectionReportState({required this.report,required this.exist});
}

class ErrorLoadingObjectionReportState extends UserState {
  final Failure failure;
  const ErrorLoadingObjectionReportState({required this.failure});
}

class LoadingObjectionReportsState extends UserState {}

class LoadedObjectionReportsState extends UserState {
  final List<ObjectionReportModel> reports;
  const LoadedObjectionReportsState({required this.reports});
}

class ErrorLoadingObjectionReportsState extends UserState {
  final Failure failure;
  const ErrorLoadingObjectionReportsState({required this.failure});
}

class LoadingFavouritesState extends UserState {}

class LoadedFavouritesState extends UserState {
  final List<FavouritesModel> items;
  const LoadedFavouritesState({required this.items});
}

class ErrorLoadingFavouritesState extends UserState {
  final Failure failure;
  const ErrorLoadingFavouritesState({required this.failure});
}