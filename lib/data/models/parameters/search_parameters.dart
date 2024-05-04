
import 'package:equatable/equatable.dart';

class SearchParameters extends Equatable {
  final String text;

  const SearchParameters({
    required this.text,
  });
  
  @override
  List<Object> get props => [text];
}
