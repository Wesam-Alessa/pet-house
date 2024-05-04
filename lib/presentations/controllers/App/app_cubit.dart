import 'dart:async';

import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/data/models/intellectual_property_rights_model.dart';
import 'package:pet_house/data/models/splash_model.dart';
import 'package:pet_house/domain/usecase/intellectual_property_rights/get_intellectual_property_rights_usecase.dart';
import 'package:pet_house/domain/usecase/intellectual_property_rights/update_intellectual_property_rights_usecase.dart';
import 'package:pet_house/domain/usecase/splash/get_splash_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/parameters/no_parameters.dart';

part 'app_state.dart';

IntellectualPropertyRightsModel? globalIntellectualPropertyRights;

class AppCubit extends Cubit<AppState> {
  final SharedPreferences sharedPreferences;
  final GetSplasUseCase getSplasUseCase;
  final GetIntellectualPropertyRightsUseCase
      getIntellectualPropertyRightsUseCase;
  final UpdateIntellectualPropertyRightsUseCase
      updateIntellectualPropertyRightsUseCase;

  AppCubit(
      this.sharedPreferences,
      this.getSplasUseCase,
      this.getIntellectualPropertyRightsUseCase,
      this.updateIntellectualPropertyRightsUseCase)
      : super(AppInitial());

  List<SplashModel> splashes = [];
  bool? splashSharedValue;
  bool? activeSharedValue;
  void init(BuildContext context) {
    getSplashAndActiveSharedValue(context);
  }

  FutureOr<void> getIntellectualPropertyRights(BuildContext context) async {
    try {
      emit(LoadingIntellectualPropertyRightsState());
      final result =
          await getIntellectualPropertyRightsUseCase(const NoParameters());
      result.fold((l) {
        globalIntellectualPropertyRights = null;
        emit(ErrorIntellectualPropertyRightsState(failuer: l));
      }, (r) {
        globalIntellectualPropertyRights = r;
        emit(LoadedIntellectualPropertyRightsState(model: r));
      });
    } on ServerException catch (e) {
      globalIntellectualPropertyRights = null;
      emit(ErrorIntellectualPropertyRightsState(
          failuer: ServerFailure(e.errorMessageModel.statusMessage)));
    }
  }

  FutureOr<void> updateIntellectualPropertyRights(
      BuildContext context, IntellectualPropertyRightsModel model) async {
    try {
      emit(LoadingIntellectualPropertyRightsState());
      final result = await updateIntellectualPropertyRightsUseCase(model);
      result.fold((l) {
        globalIntellectualPropertyRights = null;
        emit(ErrorIntellectualPropertyRightsState(failuer: l));
      }, (r) {
        globalIntellectualPropertyRights = r;
        emit(LoadedIntellectualPropertyRightsState(model: r));
      });
    } on ServerException catch (e) {
      globalIntellectualPropertyRights = null;
      emit(ErrorIntellectualPropertyRightsState(
          failuer: ServerFailure(e.errorMessageModel.statusMessage)));
    }
  }

  FutureOr<void> getSplashes(BuildContext context) async {
    try {
      emit(LoadingSplach());
      final result = await getSplasUseCase(const NoParameters());
      result.fold((l) {
        splashes = [];
        emit(ErrorSplach(failuer: l));
      }, (r) {
        splashes = r;
        emit(LoadedSplach(splashes: r));
      });
    } on ServerException catch (e) {
      splashes = [];
      emit(ErrorSplach(
          failuer: ServerFailure(e.errorMessageModel.statusMessage)));
    }
  }

  Future<void> setSplashSharedValue() async {
    await sharedPreferences.setBool('splash', true);
  }

  void getSplashAndActiveSharedValue(BuildContext context) {
    emit(LoadingSplachSharedValueState());
    splashSharedValue = sharedPreferences.getBool('splash') ?? false;
    activeSharedValue = sharedPreferences.getBool('active') ?? false;
    emit(LoadedSplachSharedValueState(
        splashSharedValue: splashSharedValue!,
        activeSharedValue: activeSharedValue!));
    if (splashSharedValue == false) {
      getSplashes(context);
    }
  }
}
