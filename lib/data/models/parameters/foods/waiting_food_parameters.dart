import 'package:equatable/equatable.dart';

class WaitingFoodParameters extends Equatable {
final String foodID;

  const WaitingFoodParameters({
  required this.foodID,
  });
@override
List<Object> get props => [foodID];
}