import 'package:equatable/equatable.dart';

class UserPetParameters extends Equatable {
  final String petID;
  final String type;

  const UserPetParameters({
    required this.petID,
    required this.type,
  });
  @override
  List<Object> get props => [petID,type];
}