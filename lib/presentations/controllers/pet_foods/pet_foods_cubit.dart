import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/error/show_custom_snackbar.dart';
import '../../../data/models/foods/pet_food_category.dart';
import '../../../data/models/foods/pet_foods_model.dart';
import '../../../data/models/parameters/foods/pet_food_category_parameters.dart';
import '../../../data/models/parameters/foods/remove_food_reports_parameters.dart';
import '../../../data/models/parameters/foods/waiting_food_parameters.dart';
import '../../../data/models/parameters/item_deletion_report_parameters.dart';
import '../../../data/models/parameters/no_parameters.dart';
import '../../../data/models/parameters/search_parameters.dart';
import '../../../domain/usecase/categories/foods/add_new_foods_category_usecase.dart';
import '../../../domain/usecase/categories/foods/get_foods_category_usecase.dart';
import '../../../domain/usecase/categories/foods/update_foods_category_usecase.dart';
import '../../../domain/usecase/foods/add_new_food_usecase.dart';
import '../../../domain/usecase/foods/foods_search/foods_search_usecase.dart';
import '../../../domain/usecase/foods/get_foods_usecase.dart';
import '../../../domain/usecase/foods/reported_foods/get_reported_foods_usecase.dart';
import '../../../domain/usecase/foods/reported_foods/remove_food_reports_usecase.dart';
import '../../../domain/usecase/foods/waiting_foods/get_waiting_foods_usecase.dart';
import '../../../domain/usecase/foods/waiting_foods/publish_waiting_food_usecase.dart';
import '../../../domain/usecase/reports/post_item_deletion_report_usecase.dart';

part 'pet_foods_state.dart';
List<PetFoodsCategoryModel> globalPetFoodsCategories = [];
List<PetFoodsModel> globalWaitingFoods = [];
List<PetFoodsModel> globalFoods = [];
class PetFoodsCubit extends Cubit<PetFoodsState> {
  final GetPetFoodsCategoriesUseCase getPetFoodsCategoriesUseCase;
  final AddNewPetFoodsCategoriesUseCase addNewPetFoodsCategoriesUseCase;
  final UpdatePetFoodsCategoryUseCase updatePetFoodsCategoryUseCase;
  final GetFoodsReportedUseCase getFoodsReportedUseCase;
  final RemoveFoodReportsUseCase removeFoodReportsUseCase;
  final AddNewFoodUseCase  addNewFoodUseCase;
  final GetFoodsUseCase getFoodsUseCase;
  final GetWaitingFoodsUseCase getWaitingFoodsUseCase;
  final PublishWaitingFoodUseCase publishWaitingFoodUseCase;
  final FoodsSearchUseCase foodsSearchUseCase;
  final PostItemDeletionReportUseCase postItemDeletionReportUseCase;

  PetFoodsCubit(
      this.getPetFoodsCategoriesUseCase,
      this.addNewPetFoodsCategoriesUseCase,
      this.updatePetFoodsCategoryUseCase,
      this.getFoodsReportedUseCase,
      this.removeFoodReportsUseCase,
      this.addNewFoodUseCase,
      this.getFoodsUseCase,
      this.getWaitingFoodsUseCase,
      this.publishWaitingFoodUseCase,
      this.foodsSearchUseCase,
      this.postItemDeletionReportUseCase,
      ) : super(InitialState());
  List<PetFoodsCategoryModel> petFoodsCategories = [];
  List<PetFoodsModel> foods = [];


  FutureOr<void> postFoodReportedDeletionReport(BuildContext context,
      List<PetFoodsModel> list, ItemDeletionReportParameters parameters) async {
    try {
      emit(const LoadingFoodsReportedState());
      final result = await postItemDeletionReportUseCase(parameters);
      result.fold(
            (l) {
          emit( ErrorFoodsReportedState( foodsReported: list));
        },
            (r) {
          showSuccess(context, r.statusMessage);
          list.removeWhere((element) => element.id == parameters.itemId);
          emit(LoadedFoodsReportedState(foodsReported: list));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedFoodsReportedState(foodsReported: list));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addNewFood(
      BuildContext context, PetFoodsModel newFood, List<PetFoodsModel> foods) async {
    try {
      emit(LoadingFoodsState());
      final result = await addNewFoodUseCase(newFood);
      result.fold(
            (l) {

          emit(LoadedFoodsState(foods: foods));
          showError(context, 'Something Wrong When Added New Food');
        },
            (r) {
              foods.add(r);
          emit(LoadedFoodsState(foods: foods));
          showSuccess(context, 'Add New Food Successfully');
        },
      );
    } on ServerException catch (e) {

      foods = foods;
      emit(LoadedFoodsState(foods: foods));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getWaitingFoods(BuildContext context) async {
    try {
      emit(const LoadingWaitingFoodsState());
      final result = await getWaitingFoodsUseCase(const NoParameters());
      result.fold(
            (l) {
          globalWaitingFoods = [];
          emit(const ErrorWaitingFoodsState(waitingFoods: []));
        },
            (r) {
          globalWaitingFoods = r;
          emit(LoadedWaitingFoodsState(waitingFoods: r));
        },
      );
    } on ServerException catch (e) {
      globalWaitingFoods = [];
      emit(const ErrorWaitingFoodsState(waitingFoods: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> publishWaitingFoods(BuildContext context, String fid) async {
    try {
      emit(const LoadingWaitingFoodsState());
      final result =
      await publishWaitingFoodUseCase(WaitingFoodParameters(foodID: fid));
      result.fold(
            (l) {
          showError(context, 'Error Publish Waiting Food');
          emit(ErrorWaitingFoodsState(waitingFoods: globalWaitingFoods));
        },
            (r) {
          globalWaitingFoods.removeWhere((element) => element.id == r.id);
          showSuccess(context, 'Published Food Successfully');
          emit(LoadedWaitingFoodsState(waitingFoods: globalWaitingFoods));
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
      emit(LoadedWaitingFoodsState(waitingFoods: globalWaitingFoods));
    }
  }

  FutureOr<void> removeFoodReports(
      BuildContext context, List<PetFoodsModel> list, String fid) async {
    try {
      emit(const LoadingFoodsReportedState());
      final result =
      await removeFoodReportsUseCase(RemoveFoodReportsParameters( foodID: fid));
      result.fold(
            (l) {
          showError(context, 'Error Remove Food Reports');
          emit(ErrorFoodsReportedState(foodsReported: list));
        },
            (r) {
          list.removeWhere((element) => element.id == fid);
          showSuccess(context, 'Remove Food Reports Successfully');
          emit(LoadedFoodsReportedState(foodsReported: list));
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
      emit(LoadedFoodsReportedState(foodsReported: list));
    }
  }

  FutureOr<void> getFoodsReported(BuildContext context) async {
    try {
      emit(const LoadingFoodsReportedState());
      final result = await getFoodsReportedUseCase(const NoParameters());
      result.fold(
            (l) {
          emit(const ErrorFoodsReportedState( foodsReported: []));
        },
            (r) {
          emit(LoadedFoodsReportedState(foodsReported: r));
        },
      );
    } on ServerException catch (e) {
      emit(const ErrorFoodsReportedState(foodsReported: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getFoods(BuildContext context, String category) async {
    try {
      emit(LoadingFoodsState());
      final result =
      await getFoodsUseCase(PetFoodCategoryParameters(category: category));
      result.fold(
            (l) {
              foods = [];
          emit(ErrorFoodsState(failure: l));
        },
            (r) {
          emit(LoadedFoodsState(foods: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorFoodsState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void searchFood({required BuildContext context, required String text}) async {
    try {
      emit(LoadingSearchState());
      final result = await foodsSearchUseCase(SearchParameters(text: text));
      result.fold(
            (l) {
          emit(ErrorSearchState(failure: l));
        },
            (r) {
          emit(LoadedSearchState(search: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorSearchState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void clearSearchPets() {
    emit(const LoadedSearchState(search: []));
  }



  FutureOr<void> updatePetFoodsCategory(
      BuildContext context, PetFoodsCategoryModel category) async {
    try {
      emit(LoadingPetFoodsCategoriesState());
      final result = await updatePetFoodsCategoryUseCase(category);
      result.fold(
            (l) {
          emit(LoadedPetFoodsCategoriesState(categories: petFoodsCategories));
        },
            (r) {
          globalPetFoodsCategories.removeWhere((element) => element.id == r.id);
          globalPetFoodsCategories.add(r);
          petFoodsCategories.clear();
          for (var c in globalPetFoodsCategories) {
            if (!c.hidden) {
              petFoodsCategories.add(c);
            }
          }
          emit(LoadedPetFoodsCategoriesState(categories: petFoodsCategories));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedPetFoodsCategoriesState(categories: petFoodsCategories));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addNewPetFoodsCategory(BuildContext context, List<PetFoodsCategoryModel> pets,
      String label, File picture) async {
    try {
      emit(LoadingPetFoodsCategoriesState());
      final result = await addNewPetFoodsCategoriesUseCase(PetFoodsCategoryModel(
          id: '', imageUrl: '', label: label, picture: picture, hidden: false));
      result.fold(
            (l) {
              petFoodsCategories = [];
          emit(ErrorLoadingPetFoodsCategoriesState(failure: l));
        },
            (r) {
              petFoodsCategories = r;
          globalPetFoodsCategories = r;
          emit(LoadedPetFoodsCategoriesState(categories: petFoodsCategories));
        },
      );
    } on ServerException catch (e) {
      petFoodsCategories = [];
      emit(ErrorLoadingPetFoodsCategoriesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getPetFoodsCategories(BuildContext context) async {
    try {
      emit(LoadingPetFoodsCategoriesState());
      final result = await getPetFoodsCategoriesUseCase(const NoParameters());
      result.fold(
            (l) {
          emit(ErrorLoadingPetFoodsCategoriesState(failure: l));
        },
            (r) {
          globalPetFoodsCategories.clear();
          petFoodsCategories.clear();
          globalPetFoodsCategories = r;

          for (var c in r) {
            if (!c.hidden) {
              petFoodsCategories.add(c);
            }
          }
          emit(LoadedPetFoodsCategoriesState(categories: petFoodsCategories));
        },
      );
    } on ServerException catch (e) {
      petFoodsCategories = [];
      emit(ErrorLoadingPetFoodsCategoriesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }

  showSuccess(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.successSnackBar(message));
  }
}
