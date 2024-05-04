
import 'package:equatable/equatable.dart';

class WaitingPetParameters extends Equatable {
  final String petID;

  const WaitingPetParameters({
    required this.petID,
  });
  @override
  List<Object> get props => [petID];
}
