import 'package:equatable/equatable.dart';

class PetCategoryParameters extends Equatable {
  final String category;

  const PetCategoryParameters({
    required this.category,
  });
  @override
  List<Object> get props => [category];
}
