// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final int statusCode;
  final String statusMessage;
  final bool success;

  const ErrorMessageModel({
    required this.statusCode,
    required this.statusMessage,
    required this.success,
  });
  
  @override
  List<Object?> get props => [statusCode,statusMessage,success];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'success': success,
    };
  }

  factory ErrorMessageModel.fromMap(Map<String, dynamic> map) {
    return ErrorMessageModel(
      statusCode: map['"status_code'] as int,
      statusMessage: map['status_message'] as String,
      success: map['success'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorMessageModel.fromJson(String source) => ErrorMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}