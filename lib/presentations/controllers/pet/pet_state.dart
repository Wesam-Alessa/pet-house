part of 'pet_cubit.dart';

abstract class PetState {
  const PetState();
}

class InitialState extends PetState {}

class LoadingState extends PetState {
}

class LoadedState extends PetState {
  final List<PetModel> pets;
  final List<PetCategoryModel> petCategories;
  const LoadedState({required this.pets, required this.petCategories});
}

class ErrorState extends PetState {
  final Failure failure;
  const ErrorState({required this.failure});
}

class LoadingCategoriesState extends PetState {
}

class LoadedCategoriesState extends PetState {
  final List<PetCategoryModel> categories;
  const LoadedCategoriesState({required this.categories});

}

class ErrorCategoriesState extends PetState {
  final Failure failure;
  const ErrorCategoriesState({required this.failure});
}

class LoadingPetsState extends PetState {
}

class LoadedPetsState extends PetState {
  final List<PetModel> pets;
  const LoadedPetsState({required this.pets});

}

class ErrorPetsState extends PetState {
  final Failure failure;
  const ErrorPetsState({required this.failure});
}


class LoadingSearchState extends PetState {
}

class LoadedSearchState extends PetState {
  final SearchModel search;
  const LoadedSearchState({required this.search});

}

class ErrorSearchState extends PetState {
  final Failure failure;
  const ErrorSearchState({required this.failure});
}

class LoadingFilterPetsState extends PetState {}

class LoadedFilterPetsState extends PetState {
  final List<PetModel> petsCategory;
  const LoadedFilterPetsState({required this.petsCategory});
}

class LoadingWaitingPetsState extends PetState {
  const LoadingWaitingPetsState();
}
class LoadedWaitingPetsState extends PetState {
  final List<PetModel> waitingPets;

  const LoadedWaitingPetsState({required this.waitingPets});
}
class ErrorWaitingPetsState extends PetState {
  final List<PetModel> waitingPets;
  const ErrorWaitingPetsState({required this.waitingPets});
}

class LoadingPetsReportedState extends PetState {
  const LoadingPetsReportedState();
}
class LoadedPetsReportedState extends PetState {
  final List<PetModel> petsReported;

  const LoadedPetsReportedState({required this.petsReported});
}
class ErrorPetsReportedState extends PetState {
  final List<PetModel> petsReported;
  const ErrorPetsReportedState({required this.petsReported});
}