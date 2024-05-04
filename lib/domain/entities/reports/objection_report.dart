
import 'package:equatable/equatable.dart';

class ObjectionReport extends Equatable{
    final String id;
    final String email;
    final String content;
    final String answer;
    final DateTime date;
    final DateTime responseDate;

    const ObjectionReport({
        required this.id,
        required this.email,
        required this.content,
        required this.answer,
        required this.date,
        required this.responseDate,
    });

      @override
      List<Object> get props => [id,email,content,answer,date,responseDate];
}