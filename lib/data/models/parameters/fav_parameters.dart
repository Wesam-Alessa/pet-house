import 'package:equatable/equatable.dart';

class FavParameters extends Equatable {
  final String id;
  final String type;

  const FavParameters({
    required this.id,required this.type,
  });
  @override
  List<Object> get props => [id,type];
}