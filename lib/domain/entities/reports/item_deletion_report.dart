import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/domain/entities/reports/item_owner.dart';
import 'package:equatable/equatable.dart';

class ItemDeletionReport extends Equatable {
  final dynamic item;
  final ItemOwner owner;
  final UserModel admin;
  final String content;
  final String deletedAt;
  final String reportID;
  final String type;
  const ItemDeletionReport({
    required this.item,
    required this.owner,
    required this.admin,
    required this.content,
    required this.deletedAt,
    required this.reportID,
    required this.type,
  });

  @override
  List<Object?> get props => [item, owner, admin, content,deletedAt,reportID,type];
}
