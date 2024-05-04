import 'package:equatable/equatable.dart';

class ItemDeletionReportParameters extends Equatable {
  final String itemId;
  final String ownerId;
  final String adminId;
  final String content;
  final String type;
  const ItemDeletionReportParameters({
    required this.itemId,
    required this.ownerId,
    required this.adminId,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [itemId, ownerId, adminId, content,type];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'ownerId': ownerId,
      'adminId': adminId,
      'content': content,
      'type':type,
    };
  }
}

class DeleteItemDeletionReportParameters extends Equatable {
  final String reportID;
  final String publisherID;
  const DeleteItemDeletionReportParameters({required this.reportID,required this.publisherID});

  @override
  List<Object?> get props => [reportID,publisherID];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reportID': reportID,
      'publisherID':publisherID,
      };
  }
}

class AddReportParameters extends Equatable {
  final String itemID;
  final String type;
  const AddReportParameters({required this.itemID,required this.type});

  @override
  List<Object?> get props => [itemID,type];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemID': itemID,
       'type':type
      };
  }
}