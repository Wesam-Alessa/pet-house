import 'dart:convert';

import '../../../domain/entities/reports/objection_report.dart';

ObjectionReportModel objectionReportModelFromJson(String str) => ObjectionReportModel.fromJson(json.decode(str));

String objectionReportModelToJson(ObjectionReportModel data) => json.encode(data.toJson());

class ObjectionReportModel extends ObjectionReport{

   const ObjectionReportModel({
        required super.id,
        required super.email,
        required super.content,
        required super.answer,
        required super.date,
        required super.responseDate,
    });

    factory ObjectionReportModel.fromJson(Map<String, dynamic> json) => ObjectionReportModel(
        id: json["_id"],
        email: json["email"],
        content: json["content"],
        answer: json["answer"],
        date: DateTime.parse(json["date"]),
        responseDate: DateTime.parse(json["responseDate"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "content": content,
        "answer": answer,
        "date": date.toIso8601String(),
        "responseDate": responseDate.toIso8601String(),
    };
}