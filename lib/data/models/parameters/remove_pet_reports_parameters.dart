
import 'package:equatable/equatable.dart';

class RemovePetReportsParameters extends Equatable {
  final String petID;

  const RemovePetReportsParameters({
    required this.petID,
  });
  @override
  List<Object> get props => [petID];
}
