
import 'dart:convert';

SendMessageModel sendMessageFromJson(String str) => SendMessageModel.fromJson(json.decode(str));

String sendMessageToJson(SendMessageModel data) => json.encode(data.toJson());

class SendMessageModel {
    final String content;
    final String chatId;
    final String receiver;

    SendMessageModel({
        required this.content,
        required this.chatId,
        required this.receiver,
    });

    factory SendMessageModel.fromJson(Map<String, dynamic> json) => SendMessageModel(
        content: json["content"],
        chatId: json["chatId"],
        receiver: json["receiver"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "chatId": chatId,
        "receiver": receiver,
    };
}
