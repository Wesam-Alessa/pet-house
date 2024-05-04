import 'dart:convert';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/domain/entities/conversation/chat/get_chat.dart';
import 'package:pet_house/presentations/screen/conversation/message_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidget extends StatefulWidget {
  final GetChatModel chat;
  final bool online;

  const ChatWidget({Key? key, required this.chat, required this.online})
      : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String uid = '';

  @override
  void initState() {
    SharedPreferences shared = getIt();
    uid = jsonDecode(shared.getString('user') ?? "")['_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors().borderColor),
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        tileColor: AppColors().backgroundColorCardContainer,
        onTap: () {
          var chat = widget.chat;
          //chat.messages = chat.messages.reversed.toList();
          //Navigator.pushNamed(context, MESSAGE_SCREEN, arguments: chat,);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => MessageScreen(chat: chat)));
        },
        leading: Stack(
          children: [
            widget.chat.users[0].id == uid
                ? widget.chat.users[1].picture.isNotEmpty
                    ? CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppColors().backgroundColorCircleAvatar,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.chat.users[1].picture))
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppColors().backgroundColorCircleAvatar,
                        backgroundImage: const AssetImage("assets/profile.png"))
                : widget.chat.users[0].picture.isNotEmpty
                    ? CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppColors().backgroundColorCircleAvatar,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.chat.users[0].picture))
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppColors().backgroundColorCircleAvatar,
                        backgroundImage:
                            const AssetImage("assets/profile.png")),
            // CircleAvatar(
            //   radius: 30,
            //   backgroundColor: AppColors().backgroundColorCircleAvatar,
            //   backgroundImage:
            //
            //   widget.chat.users[1].picture.isNotEmpty ?
            //    CachedNetworkImageProvider(widget.chat.users[1].picture)
            //    : const AssetImage("assets/profile.png")
            //       :
            //   widget.chat.users[0].picture.isNotEmpty ?
            //        CachedNetworkImageProvider(widget.chat.users[0].picture)
            //       : const AssetImage("assets/profile.png")
            //   // CachedNetworkImageProvider(
            //   //     widget.chat.users[0].id == uid
            //   //         ? widget.chat.users[1].picture
            //   //         : widget.chat.users[0].picture),
            // ),
            Positioned(
              right: 3,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: widget.online ? Colors.green : Colors.grey,
              ),
            )
          ],
        ),
        title: Text(
          widget.chat.users[0].id == uid
              ? widget.chat.users[1].name
              : widget.chat.users[0].name,
          style: TextStyles.sectionNameTextStyle,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.chat.latestMessage == null
                ? ''
                : widget.chat.latestMessage!.content,
            style: TextStyles.descriptionTextStyle,
          ),
        ),
        trailing:
            //widget.chat.unReadCount
            // 1 > 0
            //     ?
            Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(5),
            //   decoration: const BoxDecoration(
            //       shape: BoxShape.circle, color: Colors.red),
            //   child: Text(
            //     '55',
            //     //widget.chat.latestMessage.content,
            //     style: theme.textTheme.bodySmall?.copyWith(
            //         fontWeight: FontWeight.w600, color: Colors.white),
            //   ),
            // ),

            Text(
              widget.chat.latestMessage == null
                  ? ''
                  : DateFormat('MMM d, h:mm a').format(DateTime.parse(
                      widget.chat.latestMessage!.createdAt.toString())),
              style: TextStyles.descriptionTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              widget.chat.chatName == uid
                  ? Icons.arrow_circle_right_outlined
                  : Icons.arrow_circle_left_outlined,
              color: AppColors().iconColor,
            ),
          ],
        )
        // : Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Text(
        //         DateFormat('MMM d, h:mm a').format(DateTime.parse(
        //             widget.chat.latestMessage.createdAt.toString())),
        //         style: theme.textTheme.bodyText2
        //             ?.copyWith(color: Colors.blueGrey.shade300),
        //       ),
        //       const SizedBox(height: 5)
        //     ],
        //   ),
        );
  }
}
