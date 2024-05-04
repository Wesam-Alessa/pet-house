import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/domain/entities/conversation/messaging/received_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class MessageWidget extends StatelessWidget {
  final ReceivedMessageModel message;
  final String uid;

  const MessageWidget({Key? key, required this.message, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: message.sender.id == uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.sender.id != uid && message.sender.picture.isNotEmpty)
            CircleAvatar(
                radius: Dimensions.radius15,
                backgroundImage: NetworkImage(message.sender.picture)),
          if (message.sender.id != uid && message.sender.picture.isEmpty)
            CircleAvatar(
                radius: Dimensions.radius15,
                backgroundImage: const AssetImage("assets/profile.png")),
          // : const CircleAvatar(
          //     backgroundImage: AssetImage("assets//profile.png")),
          ChatBubble(
            alignment: message.sender.id == uid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            backGroundColor: message.sender.id == uid
                ? AppColors().messageBackgroundColorGrey
                : AppColors().messageBackgroundColorBlue,
            elevation: 0,
            clipper: ChatBubbleClipper4(
                radius: Dimensions.radius15 / 2,
                type: message.sender.id == uid
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble),
            child: Container(
              constraints: BoxConstraints(maxWidth: Dimensions.screenWidth / 2),
              child: Text(
                message.content,
                style: TextStyles.messageTextStyle,
              ),
            ),
          ),
          if (message.sender.id == uid && message.sender.picture.isNotEmpty)
            CircleAvatar(
                radius: Dimensions.radius15,
                backgroundImage: NetworkImage(
                  message.sender.picture,
                )),
          if (message.sender.id == uid && message.sender.picture.isEmpty)
            CircleAvatar(
                radius: Dimensions.radius15,
                backgroundImage: const AssetImage("assets/profile.png")),
          // CircleAvatar(
          //     radius: Dimensions.radius15,
          //     backgroundImage: NetworkImage(
          //       message.sender.picture,
          //     )),
        ],
      ),
    );

    // final theme = Theme.of(context);
    // if (message.sender.id == uid) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       Container(
    //         constraints: const BoxConstraints(maxWidth: 250),
    //         padding: const EdgeInsets.all(8),
    //         margin: const EdgeInsets.only(right: 8, bottom: 8),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(8),
    //           color: const Color(0xff1972F5),
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             Text(message.content,
    //                 style: theme.textTheme.bodyText2
    //                     ?.copyWith(color: Colors.white)),
    //             const SizedBox(
    //               height: 4,
    //             ),
    //             Text(
    //                 DateFormat('MMM d, h:mm a')
    //                     .format(DateTime.parse(message.createdAt.toString())),
    //                 style: theme.textTheme.bodySmall
    //                     ?.copyWith(color: Colors.grey.shade300)),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // } else {
    //   return Row(
    //     children: [
    //       Container(
    //         constraints: const BoxConstraints(maxWidth: 250),
    //         padding: const EdgeInsets.all(8),
    //         margin: const EdgeInsets.only(left: 8, bottom: 8),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(8),
    //           color: const Color.fromARGB(255, 225, 231, 236),
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(message.content, style: theme.textTheme.bodyText2),
    //             const SizedBox(
    //               height: 4,
    //             ),
    //             Text(
    //                 DateFormat('MMM d, h:mm a')
    //                     .format(DateTime.parse(message.createdAt.toString())),
    //                 style: theme.textTheme.bodySmall),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
  }
// }
}
