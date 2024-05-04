import 'dart:convert';

InitialChatModel initialChatFromJson(String str) =>
    InitialChatModel.fromJson(json.decode(str));

String initialChatToJson(InitialChatModel data) => json.encode(data.toJson());

class InitialChatModel {
  final String id;
  final int offset;
  InitialChatModel({
    required this.id,
    required this.offset,
  });

  factory InitialChatModel.fromJson(Map<String, dynamic> json) =>
      InitialChatModel(
        id: json["_id"],
        offset: json['offset'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}
