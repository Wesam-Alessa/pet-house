import 'package:equatable/equatable.dart';

class ObjectionReportParameters extends Equatable{
  final String email;
  final String content;
  const ObjectionReportParameters({required this.content,required this.email});

  @override
  List<Object?> get props => [content,email];
}