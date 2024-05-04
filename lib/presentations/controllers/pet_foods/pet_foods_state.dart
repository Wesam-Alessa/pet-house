part of 'pet_foods_cubit.dart';


abstract class PetFoodsState {
  const PetFoodsState();
}

class InitialState extends PetFoodsState {}

class LoadingPetFoodsCategoriesState extends PetFoodsState {
}

class LoadedPetFoodsCategoriesState extends PetFoodsState {
  final List<PetFoodsCategoryModel> categories;
  const LoadedPetFoodsCategoriesState({required this.categories});

}

class ErrorLoadingPetFoodsCategoriesState extends PetFoodsState {
  final Failure failure;
  const ErrorLoadingPetFoodsCategoriesState({required this.failure});
}




class LoadingFoodsState extends PetFoodsState {
}

class LoadedFoodsState extends PetFoodsState {
  final List<PetFoodsModel> foods;
  const LoadedFoodsState({required this.foods});

}

class ErrorFoodsState extends PetFoodsState {
  final Failure failure;
  const ErrorFoodsState({required this.failure});
}

class LoadingFoodsReportedState extends PetFoodsState {
  const LoadingFoodsReportedState();
}
class LoadedFoodsReportedState extends PetFoodsState {
  final List<PetFoodsModel> foodsReported;

  const LoadedFoodsReportedState({required this.foodsReported});
}
class ErrorFoodsReportedState extends PetFoodsState {
  final List<PetFoodsModel> foodsReported;
  const ErrorFoodsReportedState({required this.foodsReported});
}

class LoadingWaitingFoodsState extends PetFoodsState {
  const LoadingWaitingFoodsState();
}
class LoadedWaitingFoodsState extends PetFoodsState {
  final List<PetFoodsModel> waitingFoods;

  const LoadedWaitingFoodsState({required this.waitingFoods});
}
class ErrorWaitingFoodsState extends PetFoodsState {
  final List<PetFoodsModel> waitingFoods;
  const ErrorWaitingFoodsState({required this.waitingFoods});
}

class LoadingSearchState extends PetFoodsState {
}

class LoadedSearchState extends PetFoodsState {
  final List<PetFoodsModel> search;
  const LoadedSearchState({required this.search});

}

class ErrorSearchState extends PetFoodsState {
  final Failure failure;
  const ErrorSearchState({required this.failure});
}