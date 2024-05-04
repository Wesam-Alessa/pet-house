
// import 'package:animal_house/data/models/user_model.dart';
// import 'package:animal_house/domain/entities/conversation/message.dart';

// // Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

// // String chatToJson(Chat data) => json.encode(data.toJson());

// class ChatModel {
//   ChatModel({
//     required this.id,
//     required this.user,
//     required this.messages,
//     required this.unReadCount,
//     required this.lastMessageAt,
//   });

//   String id;
//   UserModel user;
//   List<Message> messages;
//   int unReadCount;
//   String lastMessageAt;

//   ChatModel copy() => ChatModel(
//         id: id,
//         user: user,
//         messages: messages,
//         unReadCount: unReadCount,
//         lastMessageAt: lastMessageAt,
//       );

//   ChatModel copyWith({
//     required String id,
//     required UserModel user,
//     required List<Message> messages,
//     required int unReadCount,
//     required String lastMessageAt,
//   }) =>
//       ChatModel(
//           id: id,
//           user: user,
//           messages: messages,
//           unReadCount: unReadCount,
//           lastMessageAt: lastMessageAt);

//   factory ChatModel.fromJson(Map<String, dynamic> json,UserModel userModel) => ChatModel(
//         id: json["id"]??"",
//         user: userModel,
//         unReadCount: json["unReadCount"]??0,
//         lastMessageAt: json["lastMessageAt"]??"",
//         messages: List<Message>.from(
//             json["messages"].map((x) => Message.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user": user.toJson(),
//         "unReadCount": unReadCount,
//         "lastMessageAt": lastMessageAt,
//         "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
//       };
// }
