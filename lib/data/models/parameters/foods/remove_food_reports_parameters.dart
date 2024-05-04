import 'package:equatable/equatable.dart';

class RemoveFoodReportsParameters extends Equatable {
  final String foodID;

  const RemoveFoodReportsParameters({
    required this.foodID,
  });
  @override
  List<Object> get props => [foodID];
}
