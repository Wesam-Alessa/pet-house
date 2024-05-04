import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/error/show_custom_snackbar.dart';
import '../../../data/models/parameters/item_deletion_report_parameters.dart';
import '../../../data/models/parameters/no_parameters.dart';
import '../../../data/models/parameters/search_parameters.dart';
import '../../../data/models/parameters/tools/pet_tool_category_parameters.dart';
import '../../../data/models/parameters/tools/remove_tool_reports_parameters.dart';
import '../../../data/models/parameters/tools/waiting_tool_parameters.dart';
import '../../../data/models/tools/pet_tool_category.dart';
import '../../../data/models/tools/pet_tool_model.dart';
import '../../../domain/usecase/categories/tools/add_new_tools_category_usecase.dart';
import '../../../domain/usecase/categories/tools/get_tools_category_usecase.dart';
import '../../../domain/usecase/categories/tools/update_tools_category_usecase.dart';
import '../../../domain/usecase/reports/post_item_deletion_report_usecase.dart';
import '../../../domain/usecase/tools/add_new_tool_usecase.dart';
import '../../../domain/usecase/tools/get_tools_usecase.dart';
import '../../../domain/usecase/tools/reported_tools/get_reported_tools_usecase.dart';
import '../../../domain/usecase/tools/reported_tools/remove_tool_reports_usecase.dart';
import '../../../domain/usecase/tools/tools_search/tools_search_usecase.dart';
import '../../../domain/usecase/tools/waiting_tools/get_waiting_tools_usecase.dart';
import '../../../domain/usecase/tools/waiting_tools/publish_waiting_tool_usecase.dart';
part 'tools_state.dart';
List<PetToolCategoryModel> globalToolsCategories = [];
List<PetToolModel> globalWaitingTools = [];
List<PetToolModel> globalTools = [];
class ToolsCubit extends Cubit<ToolsState> {
  final GetToolsCategoriesUseCase getToolsCategoriesUseCase;
  final AddNewToolsCategoriesUseCase addNewToolsCategoriesUseCase;
  final UpdateToolsCategoryUseCase updateToolsCategoryUseCase;
  final GetToolsReportedUseCase getToolsReportedUseCase;
  final RemoveToolReportsUseCase removeToolReportsUseCase;
  final AddNewToolUseCase  addNewToolUseCase;
  final GetToolsUseCase getToolsUseCase;
  final GetWaitingToolsUseCase getWaitingToolsUseCase;
  final PublishWaitingToolUseCase publishWaitingToolUseCase;
  final ToolsSearchUseCase toolsSearchUseCase;
  final PostItemDeletionReportUseCase postItemDeletionReportUseCase;

  ToolsCubit(
      this.addNewToolsCategoriesUseCase,
      this.getToolsCategoriesUseCase,
      this.updateToolsCategoryUseCase,
      this.getToolsReportedUseCase,
      this.removeToolReportsUseCase,
      this.addNewToolUseCase,
      this.getToolsUseCase,
      this.getWaitingToolsUseCase,
      this.publishWaitingToolUseCase,
      this.toolsSearchUseCase,
      this.postItemDeletionReportUseCase,
  ) : super(InitialState());
  List<PetToolCategoryModel> toolsCategories = [];
  List<PetToolModel> tools = [];

  FutureOr<void> postToolReportedDeletionReport(BuildContext context,
      List<PetToolModel> list, ItemDeletionReportParameters parameters) async {
    try {
      emit(const LoadingToolsReportedState());
      final result = await postItemDeletionReportUseCase(parameters);
      result.fold(
            (l) {
              emit( ErrorToolsReportedState( toolsReported: list));
        },
            (r) {
          showSuccess(context, r.statusMessage);
          list.removeWhere((element) => element.id == parameters.itemId);
          emit(LoadedToolsReportedState(toolsReported: list));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedToolsReportedState(toolsReported: list));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addNewTool(
      BuildContext context, PetToolModel newTool, List<PetToolModel> tools) async {
    try {
      emit(LoadingToolsState());
      final result = await addNewToolUseCase(newTool);
      result.fold(
            (l) {
          //     tools = tools;
          emit(LoadedToolsState(tools: tools));
          showError(context, 'Something Wrong When Added New Tool');
        },
            (r) {
              tools.add(r);
              //globalTools.add(r);
          emit(LoadedToolsState(tools: tools));
          showSuccess(context, 'Add New Tool Successfully');
        },
      );
    } on ServerException catch (e) {
      log("message here");
      tools = tools;
      emit(LoadedToolsState(tools: tools));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getWaitingTools(BuildContext context) async {
    try {
      emit(const LoadingWaitingToolsState());
      final result = await getWaitingToolsUseCase(const NoParameters());
      result.fold(
            (l) {
          globalWaitingTools = [];
          emit(const ErrorWaitingToolsState(waitingTools: []));
        },
            (r) {
          globalWaitingTools = r;
          emit(LoadedWaitingToolsState(waitingTools: r));
        },
      );
    } on ServerException catch (e) {
      globalWaitingTools = [];
      emit(const ErrorWaitingToolsState(waitingTools: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> publishWaitingTools(BuildContext context, String tid) async {
    try {
      emit(const LoadingWaitingToolsState());
      final result =
      await publishWaitingToolUseCase(WaitingToolParameters(toolID: tid));
      result.fold(
            (l) {
          showError(context, 'Error Publish Waiting Tool');
          emit(ErrorWaitingToolsState(waitingTools: globalWaitingTools));
        },
            (r) {
          globalWaitingTools.removeWhere((element) => element.id == r.id);
          showSuccess(context, 'Published Tool Successfully');
          emit(LoadedWaitingToolsState(waitingTools: globalWaitingTools));
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
      emit(LoadedWaitingToolsState(waitingTools: globalWaitingTools));
    }
  }

  FutureOr<void> removeToolReports(
      BuildContext context, List<PetToolModel> list, String tid) async {
    try {
      emit(const LoadingToolsReportedState());
      final result =
      await removeToolReportsUseCase(RemoveToolReportsParameters( toolID: tid));
      result.fold(
            (l) {
          showError(context, 'Error Remove Pet Reports');
          emit(ErrorToolsReportedState(toolsReported: list));
        },
            (r) {
          list.removeWhere((element) => element.id == tid);
          showSuccess(context, 'Remove Pet Reports Successfully');
          emit(LoadedToolsReportedState(toolsReported: list));
        },
      );
    } on ServerException catch (e) {
      showError(context, e.errorMessageModel.statusMessage);
      emit(LoadedToolsReportedState(toolsReported: list));
    }
  }

  FutureOr<void> getToolsReported(BuildContext context) async {
    try {
      emit(const LoadingToolsReportedState());
      final result = await getToolsReportedUseCase(const NoParameters());
      result.fold(
            (l) {
          emit(const ErrorToolsReportedState( toolsReported: []));
        },
            (r) {
          emit(LoadedToolsReportedState(toolsReported: r));
        },
      );
    } on ServerException catch (e) {
      emit(const ErrorToolsReportedState(toolsReported: []));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getTools(BuildContext context, String category) async {
    try {
      emit(LoadingToolsState());
      final result =
      await getToolsUseCase(PetToolCategoryParameters(category: category));
      result.fold(
            (l) {
              tools = [];
          emit(ErrorToolsState(failure: l));
        },
            (r) {
          emit(LoadedToolsState(tools: r));
        },
      );
    } on ServerException catch (e) {
      emit(ErrorToolsState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> updateToolsCategory(
      BuildContext context, PetToolCategoryModel category) async {
    try {
      emit(LoadingToolsCategoriesState());
      final result = await updateToolsCategoryUseCase(category);
      result.fold(
            (l) {
          emit(LoadedToolsCategoriesState(categories: toolsCategories));
        },
            (r) {
          globalToolsCategories.removeWhere((element) => element.id == r.id);
          globalToolsCategories.add(r);
          toolsCategories.clear();
          for (var c in globalToolsCategories) {
            if (!c.hidden) {
              toolsCategories.add(c);
            }
          }
          emit(LoadedToolsCategoriesState(categories: toolsCategories));
        },
      );
    } on ServerException catch (e) {
      emit(LoadedToolsCategoriesState(categories: toolsCategories));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> addNewToolsCategory(BuildContext context, List<PetToolCategoryModel> pets,
      String label, File picture) async {
    try {
      emit(LoadingToolsCategoriesState());
      final result = await addNewToolsCategoriesUseCase(PetToolCategoryModel(
          id: '', imageUrl: '', label: label, picture: picture, hidden: false));
      result.fold(
            (l) {
              toolsCategories = [];
          emit(ErrorLoadingToolsCategoriesState(failure: l));
        },
            (r) {
              toolsCategories = r;
              globalToolsCategories = r;
          emit(LoadedToolsCategoriesState(categories: toolsCategories));
          //showSuccess(context, "Added Successfully");
        },
      );
    } on ServerException catch (e) {
      toolsCategories = [];
      emit(ErrorLoadingToolsCategoriesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  FutureOr<void> getToolsCategories(BuildContext context) async {
    try {
      emit(LoadingToolsCategoriesState());
      final result = await getToolsCategoriesUseCase(const NoParameters());
      result.fold(
            (l) {
          emit(ErrorLoadingToolsCategoriesState(failure: l));
        },
            (r) {
              globalToolsCategories.clear();
              toolsCategories.clear();
              globalToolsCategories = r;
              for (var c in r) {
            if (!c.hidden) {
              toolsCategories.add(c);
            }
          }
          emit(LoadedToolsCategoriesState(categories: toolsCategories));
        },
      );
    } on ServerException catch (e) {
      toolsCategories = [];
      emit(ErrorLoadingToolsCategoriesState(
          failure: ServerFailure(e.errorMessageModel.statusMessage)));
      showError(context, e.errorMessageModel.statusMessage);
    }
  }

  void searchTool({required BuildContext context, required String text}) async {
    try {
      emit(LoadingSearchState());
      final result = await toolsSearchUseCase(SearchParameters(text: text));
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


  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }

  showSuccess(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.successSnackBar(message));
  }
}
