part of 'tools_cubit.dart';

abstract class ToolsState {
  const ToolsState();
}

class InitialState extends ToolsState {}

class LoadingToolsCategoriesState extends ToolsState {
}

class LoadedToolsCategoriesState extends ToolsState {
  final List<PetToolCategoryModel> categories;
  const LoadedToolsCategoriesState({required this.categories});

}

class ErrorLoadingToolsCategoriesState extends ToolsState {
  final Failure failure;
  const ErrorLoadingToolsCategoriesState({required this.failure});
}

class LoadingToolsState extends ToolsState {
}

class LoadedToolsState extends ToolsState {
  final List<PetToolModel> tools;
  const LoadedToolsState({required this.tools});

}

class ErrorToolsState extends ToolsState {
  final Failure failure;
  const ErrorToolsState({required this.failure});
}

class LoadingToolsReportedState extends ToolsState {
  const LoadingToolsReportedState();
}
class LoadedToolsReportedState extends ToolsState {
  final List<PetToolModel> toolsReported;

  const LoadedToolsReportedState({required this.toolsReported});
}
class ErrorToolsReportedState extends ToolsState {
  final List<PetToolModel> toolsReported;
  const ErrorToolsReportedState({required this.toolsReported});
}

class LoadingWaitingToolsState extends ToolsState {
  const LoadingWaitingToolsState();
}
class LoadedWaitingToolsState extends ToolsState {
  final List<PetToolModel> waitingTools;

  const LoadedWaitingToolsState({required this.waitingTools});
}
class ErrorWaitingToolsState extends ToolsState {
  final List<PetToolModel> waitingTools;
  const ErrorWaitingToolsState({required this.waitingTools});
}

class LoadingSearchState extends ToolsState {
}

class LoadedSearchState extends ToolsState {
  final List<PetToolModel> search;
  const LoadedSearchState({required this.search});

}

class ErrorSearchState extends ToolsState {
  final Failure failure;
  const ErrorSearchState({required this.failure});
}