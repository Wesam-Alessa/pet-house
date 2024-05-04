
import 'dart:convert';

CreateChatModel createChatFromJson(String str) => CreateChatModel.fromJson(json.decode(str));

String createChatToJson(CreateChatModel data) => json.encode(data.toJson());

class CreateChatModel {
    final String userId;

    CreateChatModel({
        required this.userId,
    });

    factory CreateChatModel.fromJson(Map<String, dynamic> json) => CreateChatModel(
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
    };
}
