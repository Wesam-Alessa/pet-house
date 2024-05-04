// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

List<ReceivedMessageModel> receivedMessageFromJson(String str) => List<ReceivedMessageModel>.from(json.decode(str).map((x) => ReceivedMessageModel.fromJson(x)));

class ReceivedMessageModel {
    final String id;
    final Sender sender;
    final String content;
    final String receiver;
    final Chat chat;
    final List<dynamic> readBy;
    final DateTime createdAt;
    final DateTime updatedAt;

    ReceivedMessageModel({
        required this.id,
        required this.sender,
        required this.content,
        required this.receiver,
        required this.chat,
        required this.readBy,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ReceivedMessageModel.fromJson(Map<String, dynamic> json) => ReceivedMessageModel(
        id: json["_id"] ?? json["id"],
        sender: Sender.fromJson(json["sender"]),
        content: json["content"],
        receiver: json["receiver"],
        chat: Chat.fromJson(json["chat"]),
        readBy: List<dynamic>.from(json["readBy"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"].toString()),
        updatedAt: DateTime.parse(json["updatedAt"].toString()),
    );


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sender': sender.toMap(),
      'content': content,
      'receiver': receiver,
      'chat': chat.toMap(),
      'readBy': readBy,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

 
}

class Chat {
    final String id;
    final String chatName;
    final bool isGroupChat;
    final List<Sender> users;
    final String latestMessage;
    final DateTime createdAt;
    final DateTime updatedAt;

    Chat({
        required this.id,
        required this.chatName,
        required this.isGroupChat,
        required this.users,
        required this.latestMessage,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"]??json["id"],
        chatName: json["chatName"],
        isGroupChat: json["isGroupChat"],
        users: List<Sender>.from(json["users"].map((x) => Sender.fromJson(x))),
        latestMessage: json["latestMessage"]??'',
        createdAt: DateTime.parse(json["createdAt"].toString()),
        updatedAt: DateTime.parse(json["updatedAt"].toString()),
    );


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatName': chatName,
      'isGroupChat': isGroupChat,
      'users': users.map((x) => x.toMap()).toList(),
      'latestMessage': latestMessage,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

}

class Sender {
    final String id;
    final String name;
    final String email;
    final String picture;

    Sender({
        required this.id,
        required this.name,
        required this.email,
        required this.picture,
    });

    factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["_id"]??json["id"],
        name: json["name"],
        email: json["email"],
        picture: json["picture"],
    );


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'picture': picture,
    };
  }

}
