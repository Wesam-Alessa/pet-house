import 'package:equatable/equatable.dart';

class RemoveToolReportsParameters extends Equatable {
  final String toolID;

  const RemoveToolReportsParameters({
    required this.toolID,
  });
  @override
  List<Object> get props => [toolID];
}
