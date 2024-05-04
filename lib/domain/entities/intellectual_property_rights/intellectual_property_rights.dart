
import 'package:equatable/equatable.dart';

class IntellectualPropertyRights extends Equatable{
  final String id;
  final String text;

  const IntellectualPropertyRights({required this.id,required this.text});
    @override
  List<Object> get props => [id,text];
}
