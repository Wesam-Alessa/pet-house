import 'package:equatable/equatable.dart';

class PetFoodCategoryParameters extends Equatable {
  final String category;

  const PetFoodCategoryParameters({
    required this.category,
  });
  @override
  List<Object> get props => [category];
}
