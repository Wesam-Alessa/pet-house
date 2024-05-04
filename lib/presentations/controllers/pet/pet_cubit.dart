import 'dart:async';
import 'dart:io';

import 'package:pet_house/core/error/exceptions.dart';
import 'package:pet_house/core/error/show_custom_snackbar.dart';
import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/data/models/parameters/remove_pet_reports_parameters.dart';
import 'package:pet_house/data/models/parameters/search_parameters.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/domain/usecase/categories/pets/add_new_pet_category_usecase.dart';
import 'package:pet_house/domain/usecase/categories/pets/update_pet_category_usecase.dart';
import 'package:pet_house/domain/usecase/pet/add_new_pet_usecase.dart';
import 'package:pet_house/domain/usecase/categories/pets/get_pet_categories_usecase.dart';
import 'package:pet_house/domain/usecase/pet/get_pet_usecase.dart';
import 'package:pet_house/domain/usecase/pet/reported_pets/get_reported_pets_usecase.dart';
import 'package:pet_house/domain/usecase/pet/reported_pets/remove_pet_reports_usecase.dart';
import 'package:pet_house/domain/usecase/reports/post_item_deletion_report_usecase.dart';
import 'package:pet_house/domain/usecase/search/search_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/parameters/no_parameters.dart';
import '../../../data/models/parameters/pets_category_parameters.dart';
import '../../../data/models/parameters/waiting_pet_parameters.dart';
import '../../../data/models/search/search_model.dart';
import '../../../domain/usecase/pet/waiting_pets/get_waiting_pets_usecase.dart';
import '../../../domain/usecase/pet/waiting_pets/publish_waiting_pet_usecase.dart';

part 'pet_state.dart';

List<PetModel> globalPets = [];
List<PetModel> globalWaitingPets = [];
List<PetCategoryModel> globalCategories = [];

class PetCubit extends Cubit<PetState> {
  final GetPetUseCase getPetUseCase;
  final GetPetCategoriesUseCase getPetCategoriesUseCase;
  final AddNewPetUseCase addNewPetUseCase;
  final AddNewPetCategoriesUseCase addNewPetCategoriesUseCase;
  final UpdatePetCategoriesUseCase updatePetCategoriesUseCase;
  final GetWaitingPetsUseCase getWaitingPetsUseCase;
  final PublishWaitingPetUseCase publishWaitingPetUseCase;
  final PostItemDeletionReportUseCase postItemDeletionReportUseCase;
  final GetPetsReportedUseCase getPetsReportedUseCase;
  final RemovePetReportsUseCase removePetReportsUseCase;
  final SearchUseCase searchUseCase;
  PetCubit(
    this.getPetUseCase,
    this.getPetCategoriesUseCase,
    this.addNewPetUseCase,
    this.addNewPetCategoriesUseCase,
    this.updatePetCategoriesUseCase,
    this.getWaitingPetsUseCase,
    this.publishWaitingPetUseCase,
    this.postItemDeletionReportUseCase,
    this.getPetsReportedUseCase,
    this.removePetReportsUseCase,
    this.searchUseCase,
  ) : super(InitialState());
  List<PetModel> pets = [];
  List<PetCategoryModel> petCategories = [];
  // List<PetModel> search = [];

  FutureOr<void> getPets(BuildContext context, String category) async {
    try {
      emit(LoadingPetsState());
      final result =
          await getPetUseCase(PetCategoryParameters(category: category));
      result.fold(
        (l) {
          pets = [];
          emit(ErrorPetsState(failure: l));
        },
        (r) {
          // pets = r;
          // globalPets = r;
          emit(LoadedPetsState(pets: r));
        },
      );
    } on ServerException catch (e) {
      //pets = [];
      emit(ErrorPetsState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getPetsReported(BuildContext context) async {
    try {
      emit(const LoadingPetsReportedState());
      final result = await getPetsReportedUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(const ErrorPetsReportedState(petsReported: []));
        },
        (r) {
          emit(LoadedPetsReportedState(petsReported: r));
        },
      );
    } on ServerException catch (e) {
      emit(const ErrorPetsReportedState(petsReported: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> removePetReports(
      BuildContext context, List<PetModel> list, String pid) async {
    try {
      emit(const LoadingPetsReportedState());
      final result =
          await removePetReportsUseCase(RemovePetReportsParameters(petID: pid));
      result.fold(
        (l) {
          showError(context, 'Error Remove Pet Reports');
          emit(ErrorPetsReportedState(petsReported: list));
        },
        (r) {
          list.removeWhere((element) => element.id == pid);
          showSuccess(context, 'Remove Pet Reports Successfully');
          emit(LoadedPetsReportedState(petsReported: list));
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
      emit(LoadedPetsReportedState(petsReported: list));
    }
  }
  //----------
  FutureOr<void> postPetReportedDeletionReport(BuildContext context,
      List<PetModel> list, ItemDeletionReportParameters parameters) async {
    try {
      emit(const LoadingPetsReportedState());
      final result = await postItemDeletionReportUseCase(parameters);
      result.fold(
        (l) {
          emit(ErrorPetsReportedState(petsReported: list));
        },
        (r) {
          showSuccess(context, r.statusMessage);
          list.removeWhere((element) => element.id == parameters.itemId);
          emit(LoadedPetsReportedState(petsReported: list));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedPetsReportedState(petsReported: list));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }
  //----------
  FutureOr<void> getWaitingPets(BuildContext context) async {
    try {
      emit(const LoadingWaitingPetsState());
      final result = await getWaitingPetsUseCase(const NoParameters());
      result.fold(
        (l) {
          globalWaitingPets = [];
          emit(const ErrorWaitingPetsState(waitingPets: []));
        },
        (r) {
          globalWaitingPets = r;
          emit(LoadedWaitingPetsState(waitingPets: r));
        },
      );
    } on ServerException catch (e) {
      globalWaitingPets = [];
      emit(const ErrorWaitingPetsState(waitingPets: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> publishWaitingPets(BuildContext context, String pid) async {
    try {
      emit(const LoadingWaitingPetsState());
      final result =
          await publishWaitingPetUseCase(WaitingPetParameters(petID: pid));
      result.fold(
        (l) {
          showError(context, 'Error Publish Waiting Pet');
          emit(ErrorWaitingPetsState(waitingPets: globalWaitingPets));
        },
        (r) {
          globalWaitingPets.removeWhere((element) => element.id == r.id);
          showSuccess(context, 'Published Pet Successfully');
          emit(LoadedWaitingPetsState(waitingPets: globalWaitingPets));
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
      emit(LoadedWaitingPetsState(waitingPets: globalWaitingPets));
    }
  }

  FutureOr<void> postWaitingPetDeletionReport(
      BuildContext context, ItemDeletionReportParameters parameters) async {
    try {
      emit(const LoadingWaitingPetsState());
      final result = await postItemDeletionReportUseCase(parameters);
      result.fold(
        (l) {
          emit(ErrorWaitingPetsState(waitingPets: globalWaitingPets));
        },
        (r) {
          showSuccess(context, r.statusMessage);
          globalWaitingPets
              .removeWhere((element) => element.id == parameters.itemId);
          emit(LoadedWaitingPetsState(waitingPets: globalWaitingPets));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedWaitingPetsState(waitingPets: globalWaitingPets));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> updatePetCategory(
      BuildContext context, PetCategoryModel category) async {
    try {
      emit(LoadingState());
      final result = await updatePetCategoriesUseCase(category);
      result.fold(
        (l) {
          emit(LoadedState(pets: pets, petCategories: petCategories));
        },
        (r) {
          globalCategories.removeWhere((element) => element.id == r.id);
          globalCategories.add(r);
          petCategories.clear();
          for (var c in globalCategories) {
            if (!c.hidden) {
              petCategories.add(c);
            }
          }
          // petCategories.removeWhere((element) => element.id == r.id);
          // petCategories.add(r);
          emit(LoadedState(pets: pets, petCategories: petCategories));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedState(pets: pets, petCategories: petCategories));
      // emit(ErrorState(
      //     failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addNewPetCategory(BuildContext context, List<PetModel> pets,
      String label, File picture) async {
    try {
      emit(LoadingState());
      final result = await addNewPetCategoriesUseCase(PetCategoryModel(
          id: '', imageUrl: '', label: label, picture: picture, hidden: false));
      result.fold(
        (l) {
          petCategories = [];
          emit(ErrorState(failure: l));
        },
        (r) {
          petCategories = r;
          globalCategories = r;
          emit(LoadedState(pets: pets, petCategories: r));
          //showSuccess(context, "Added Successfully");
        },
      );
    } on ServerException catch (e) {
      petCategories = [];
      emit(ErrorState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addNewPet(
      BuildContext context, PetModel newPet, List<PetModel> pets) async {
    try {
      emit(LoadingState());
      final result = await addNewPetUseCase(newPet);
      result.fold(
        (l) {
          pets = pets;
          emit(LoadedState(pets: pets, petCategories: globalCategories));
          showError(context, 'Something Wrong When Added New Pet');
        },
        (r) {
          pets.add(r);
          globalPets.add(r);
          emit(LoadedState(pets: pets, petCategories: globalCategories));
          showSuccess(context, 'Add New Pet Successfully');
        },
      );
    } on ServerException catch (e) {
      pets = pets;
      emit(LoadedState(pets: pets, petCategories: globalCategories));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getPetCategories(BuildContext context) async {
    try {
      emit(LoadingState());
      final result = await getPetCategoriesUseCase(const NoParameters());
      result.fold(
        (l) {
          petCategories = [];
          emit(ErrorState(failure: l));
        },
        (r) {
          globalCategories.clear();
          petCategories.clear();
          globalCategories = r;
          for (var c in r) {
            if (!c.hidden) {
              petCategories.add(c);
            }
          }
          emit(LoadedState(pets: pets, petCategories: petCategories));
        },
      );
    } on ServerException catch (e) {
      petCategories = [];
      emit(ErrorState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getCategories(BuildContext context) async {
    try {
      emit(LoadingCategoriesState());
      final result = await getPetCategoriesUseCase(const NoParameters());
      result.fold(
        (l) {
          emit(ErrorCategoriesState(failure: l));
        },
        (r) {
          globalCategories = r;
          List<PetCategoryModel> x = [];
          for (var c in r) {
            if (!c.hidden) {
              x.add(c);
            }
          }
          emit(LoadedCategoriesState(categories: x));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorCategoriesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void searchPet({required BuildContext context, required String text}) async {
    try {
      emit(LoadingSearchState());
      //String searchKey = text[0].toLowerCase() + text.substring(1);
      final result = await searchUseCase(SearchParameters(text: text));
      result.fold(
        (l) {
          emit(ErrorSearchState(failure: l));
        },
        (r) {
          emit(LoadedSearchState(search: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void clearSearchPets() {
    emit(LoadedSearchState(search: SearchModel(pets: [],foods: [],tools: [])));
  }

  List<PetModel> petsCategory = [];

  // void filterPetsForCategory(String name, List<PetModel> petsList) {
  //   petCategories.clear();
  //   for (var element in petsList) {
  //     if (element.category == name) {
  //       petsCategory.add(element);
  //     }
  //   }
  // }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }

  showSuccess(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.successSnackBar(message));
  }
}
