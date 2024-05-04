import 'dart:convert';

import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/data/models/tools/pet_tool_model.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/entities/reports/item_deletion_report.dart';
import 'package:pet_house/domain/entities/reports/item_owner.dart';

import '../foods/pet_foods_model.dart';

class ItemDeletionReportModel extends ItemDeletionReport {
  const ItemDeletionReportModel({
    required super.item,
    required super.owner,
    required super.admin,
    required super.content,
    required super.deletedAt,
    required super.reportID,
    required super.type,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': item.toMap(),
      'ownerId': owner.toMap(),
      'adminId': admin.toJson(),
      'content': content,
      'deletedAt':deletedAt,
      'reportID':reportID,
      'type':type,
    };
  }

  factory ItemDeletionReportModel.fromMap(Map<String, dynamic> map) {
    dynamic item;
    switch(map['type']){
      case 'pet':
        item =  PetModel.fromMap(map['item']);
        break;
      case "tool":
        item =  PetToolModel.fromMap(map['item']);
        break;
      case "food":
        item =  PetFoodsModel.fromMap(map['item']);
        break;
    }
    return ItemDeletionReportModel(
          type:map['type'],
          item: item,
          owner: ItemOwner.fromMap(map['owner']),
          admin: UserModel.fromjson(map['admin']),
          content: map['content'] ?? '',
          deletedAt: map['deletedAt']??'',
          reportID:map['_id']??''
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemDeletionReportModel.fromJson(String source) =>
      ItemDeletionReportModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
