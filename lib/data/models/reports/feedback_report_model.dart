
import '../../../domain/entities/reports/feedback_report.dart';

class FeedbackReportModel extends FeedbackReport{
    FeedbackReportModel({
        required super.id,
        required super.user,
        required super.content,
        required super.date,
    });
    factory FeedbackReportModel.fromJson(Map<String, dynamic> json) => FeedbackReportModel(
        id: json["_id"],
        user: User.fromJson(json["userId"]),
        content: json["content"],
        date: DateTime.parse(json["date"]),
    );
}
