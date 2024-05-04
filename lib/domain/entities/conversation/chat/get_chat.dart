
import 'dart:convert';

List<GetChatModel> getChatsFromJson(String str) => List<GetChatModel>.from(json.decode(str).map((x) => GetChatModel.fromJson(x)));

String getChatsToJson(List<GetChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChatModel {
    final String id;
    final String chatName;
    final bool isGroupChat;
    final List<User> users;
    LatestMessage? latestMessage;
    final DateTime createdAt;
    final DateTime updatedAt;

    GetChatModel({
        required this.id,
        required this.chatName,
        required this.isGroupChat,
        required this.users,
        this.latestMessage,
        required this.createdAt,
        required this.updatedAt,
    });

    factory GetChatModel.fromJson(Map<String, dynamic> json) => GetChatModel(
        id: json["_id"],
        chatName: json["chatName"],
        isGroupChat: json["isGroupChat"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        latestMessage:json["latestMessage"] == null ? null : LatestMessage.fromJson(json["latestMessage"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "chatName": chatName,
        "isGroupChat": isGroupChat,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "latestMessage": latestMessage!.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class LatestMessage {
    final String id;
    final Sender sender;
    final String content;
    final String receiver;
    final String chat;
    final List<dynamic> readBy;
    final DateTime createdAt;
    final DateTime updatedAt;

    LatestMessage({
        required this.id,
        required this.sender,
        required this.content,
        required this.receiver,
        required this.chat,
        required this.readBy,
        required this.createdAt,
        required this.updatedAt,
    });

    factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
        id: json["_id"],
        sender: Sender.fromJson(json["sender"]),
        content: json["content"],
        receiver: json["receiver"],
        chat: json["chat"],
        readBy: List<dynamic>.from(json["readBy"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "sender": sender.toJson(),
        "content": content,
        "receiver": receiver,
        "chat": chat,
        "readBy": List<dynamic>.from(readBy.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Sender {
    final String id;
    final String name;
    final String email;

    Sender({
        required this.id,
        required this.name,
        required this.email,
    });

    factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
    };
}

class User {
    final String id;
    final String name;
    final String email;
    final String phone;
    final String address;
    final String picture;
    final List<dynamic> favourites;
    final List<dynamic> myPets;
    final bool isAdmin;
    final bool isManager;
    final List<dynamic> reports;
    final bool disabled;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.picture,
        required this.address,
        required this.favourites,
        required this.myPets,
        required this.isAdmin,
        required this.isManager,
        required this.reports,
        required this.disabled,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        picture:json['picture'],
        favourites: List<dynamic>.from(json["favourites"].map((x) => x)),
        myPets: List<dynamic>.from(json["myPets"].map((x) => x)),
        isAdmin: json["isAdmin"],
        isManager: json["isManager"],
        reports: List<dynamic>.from(json["reports"].map((x) => x)),
        disabled: json["disabled"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "picture":picture,
        "favourites": List<dynamic>.from(favourites.map((x) => x)),
        "myPets": List<dynamic>.from(myPets.map((x) => x)),
        "isAdmin": isAdmin,
        "isManager": isManager,
        "reports": List<dynamic>.from(reports.map((x) => x)),
        "disabled": disabled,
    };
}
