import 'package:equatable/equatable.dart';

class PetToolCategoryParameters extends Equatable {
  final String category;

  const PetToolCategoryParameters({
    required this.category,
  });
  @override
  List<Object> get props => [category];
}
