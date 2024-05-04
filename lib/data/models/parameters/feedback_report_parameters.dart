import 'package:equatable/equatable.dart';

class FeedbackReportParameters extends Equatable {
  final String reportId;
  final String content;
  const FeedbackReportParameters({required this.content,required this.reportId});
  @override
  List<Object?> get props => [content,reportId];
}
