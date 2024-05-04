part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class LoadingSplachSharedValueState extends AppState {}

class LoadedSplachSharedValueState extends AppState {
  final bool splashSharedValue;
  final bool activeSharedValue;

  const LoadedSplachSharedValueState(
      {required this.splashSharedValue, required this.activeSharedValue});
}

class LoadingSplach extends AppState {}

class LoadedSplach extends AppState {
  final List<SplashModel> splashes;
  const LoadedSplach({required this.splashes});
  @override
  List<Object> get props => [splashes];
}

class ErrorSplach extends AppState {
  final Failure failuer;
  const ErrorSplach({required this.failuer});
  @override
  List<Object> get props => [failuer];
}

class LoadingIntellectualPropertyRightsState extends AppState {}

class LoadedIntellectualPropertyRightsState extends AppState {
  final IntellectualPropertyRightsModel model;
  const LoadedIntellectualPropertyRightsState({required this.model});
}

class ErrorIntellectualPropertyRightsState extends AppState {
  final Failure failuer;
  const ErrorIntellectualPropertyRightsState({required this.failuer});
  @override
  List<Object> get props => [failuer];
}
