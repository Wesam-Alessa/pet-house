import 'package:equatable/equatable.dart';

class WaitingToolParameters extends Equatable {
final String toolID;

  const WaitingToolParameters({
  required this.toolID,
  });
@override
List<Object> get props => [toolID];
}