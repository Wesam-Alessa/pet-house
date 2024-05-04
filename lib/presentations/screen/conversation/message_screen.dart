import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/domain/entities/conversation/chat/get_chat.dart';
import 'package:pet_house/domain/entities/conversation/messaging/received_message.dart';
import 'package:pet_house/domain/entities/conversation/messaging/send_message.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/conversation/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/services/service_locator.dart';

class MessageScreen extends StatefulWidget {
  final GetChatModel? chat;

  const MessageScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with AnimationMixin {
  late GetChatModel chat;
  final textController = TextEditingController();
  final _scrollController = ScrollController();

  late Animation<double> opacity;
  late AnimationController slideInputController;
  late Animation<Offset> slideInputAnimation;

  bool isVisible = false;
  String uid = '';
  List<ReceivedMessageModel> messages = [];
  String receiver = '';
  int offset = 1;
  bool typing = false;

  @override
  void initState() {
    slideInputController = createController()
      ..duration = const Duration(milliseconds: 500);
    slideInputAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-2, 0),
    ).animate(slideInputController);

    opacity = Tween<double>(begin: 1, end: 0).animate(controller);
    controller.duration = const Duration(milliseconds: 200);
    SharedPreferences shared = getIt();
    uid = jsonDecode(shared.getString('user') ?? "")['_id'];
    chat = widget.chat!;
    receiver = chat.users[0].id == uid ? chat.users[1].id : chat.users[0].id;
    online = getIt.get<List<dynamic>>();
    log('online-user-message-screen => $online');
    initMessages();
    connect();
    joinChat();
    handelNext();
    super.initState();
  }



  List<dynamic> online = [];
  void changeState()=>setState(() {});
  void connect() async {
    log('Connect message-screen to front end');
    gsocket.on('typing', (status) {
      //setState(() {
        typing = true;
      //});
      getIt.get<UserCubit>().typingState = false;
      log(getIt.get<UserCubit>().typing.toString());
      log('typing => $status');
      changeState();
    });
    gsocket.on('stop typing', (status) {
      setState(() {
        typing = false;
      });
      getIt.get<UserCubit>().typingState = true;
      log(getIt.get<UserCubit>().typing.toString());
      log('stop typing => $status');
    });
    gsocket.on('message received', (newMessageReceived) {
      sendStopTypingEvent(chat.id);
      ReceivedMessageModel receivedMessageModel =
          ReceivedMessageModel.fromJson(newMessageReceived);
      if (receivedMessageModel.sender.id != uid) {
        setState(() {
          gmessages.insert(0, receivedMessageModel);
          messages = gmessages;
          log(gmessages.length.toString());
        });
      }
    });
  }

  void sendTypingEvent(String status) {
    gsocket.emit('typing', status);
  }

  void sendStopTypingEvent(String status) {
    gsocket.emit('stop typing', status);
  }

  void joinChat() {
    gsocket.emit('join chat', chat.id);
  }

  sendMessage(String text) {
    SendMessageModel model = SendMessageModel(
        content: text, chatId: chat.id, receiver: chat.users[0].id);
    getIt.get<UserCubit>().sendMessage(context, model).then((val) {
      try {
        val.fold(
          (l) {
            log("ERROR:  ");
            log(l.message);
          },
          (r) {
            sendStopTypingEvent(chat.id);
            gsocket.emit('new message', r.toMap());
            textController.clear();
            setState(() {
              gmessages.insert(0, r);
            });
          },
        );
      } on ServerException catch (e) {
        log("ServerException ERROR:  ");
        log(e.errorMessageModel.statusMessage);
      }
    });
  }

  void handelNext() {
    _scrollController.addListener(() async {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          log("<><><> Loading <><><>");
          if (messages.length >= 15) {
            await getIt
                .get<UserCubit>()
                .getMessages(context, chat.id, offset++);
            messages = gmessages;
            setState(() {});
          }
        }
      }
    });
  }

  bool loading = false;

  initMessages() async {
    setState(() {
      loading = true;
    });
    await getIt.get<UserCubit>().getMessages(context, chat.id, offset);
    messages = gmessages;
    //log("initMessages() => ${messages.length}");
    setState(() {
      loading = false;
    });
  }
  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    gmessages.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors().iconColor),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0,
          centerTitle: true,
          titleSpacing: 0,
          title: typing
              ? Text("typing.....", style: TextStyles.sectionNameTextStyle)
              : Text(
                  chat.users[0].id == uid
                      ? chat.users[1].name
                      : chat.users[0].name,
                  style: TextStyles.sectionNameTextStyle),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  chat.users[0].picture.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                          chat.users[0].id == uid
                              ? chat.users[1].picture
                              : chat.users[0].picture,
                        ))
                      : const CircleAvatar(
                          backgroundImage: AssetImage("assets/profile.png")),
                  Positioned(
                    right: 3,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          //getIt.get<UserCubit>().
                          online.contains(receiver)
                              ? Colors.green
                              : Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ),
              )
            : messages.isEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Column(
                        children: [
                          Expanded(
                              child: Center(
                            child: Text('You do not have message',
                                style: TextStyles.sectionNameTextStyle),
                          )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              color: AppColors().backgroundColorScaffold,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 8,
                                    left: 8,
                                    bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0
                                        ? 15
                                        : 28,
                                    top: 8),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: SlideTransition(
                                            position: slideInputAnimation,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: TextField(
                                                      controller:
                                                          textController,
                                                      minLines: 1,
                                                      maxLines: 5,
                                                      style: TextStyles
                                                          .textFormFieldWidgetStyle,
                                                      cursorColor: AppColors()
                                                          .borderColor,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 16,
                                                                left: 20,
                                                                bottom: 10,
                                                                top: 10),
                                                        hintText:
                                                            'Type a message',
                                                        hintStyle: TextStyles
                                                            .formLabelTextStyle,
                                                        border:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          gapPadding: 0,
                                                          borderSide: BorderSide(
                                                              color: AppColors()
                                                                  .borderColor),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          gapPadding: 0,
                                                          borderSide: BorderSide(
                                                              color: AppColors()
                                                                  .borderColor),
                                                        ),
                                                      ),
                                                      onChanged: (_) {
                                                        if (textController
                                                            .text.isEmpty) {
                                                          sendStopTypingEvent(
                                                              chat.id);
                                                        } else {
                                                          sendTypingEvent(
                                                              chat.id);
                                                        }
                                                      },
                                                      onEditingComplete: () {
                                                        sendMessage(
                                                            textController
                                                                .text);
                                                      },
                                                      onSubmitted: (_) {
                                                        sendStopTypingEvent(
                                                            chat.id);
                                                        sendMessage(
                                                            textController
                                                                .text);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          splashRadius: 20,
                                          icon: Icon(Icons.send,
                                              color: AppColors().iconColor),
                                          onPressed: () {
                                            if (textController
                                                .text.isNotEmpty) {
                                              sendMessage(textController.text);
                                              // textController.clear();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return MessageWidget(
                                  message: messages[index],
                                  uid: uid,
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              color: AppColors().backgroundColorScaffold,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 8,
                                    left: 8,
                                    bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0
                                        ? 15
                                        : 28,
                                    top: 8),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: SlideTransition(
                                            position: slideInputAnimation,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: AppColors()
                                                        .backgroundColorCardContainer,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: TextField(
                                                      controller:
                                                          textController,
                                                      minLines: 1,
                                                      maxLines: 5,
                                                      style: TextStyles
                                                          .textFormFieldWidgetStyle,
                                                      cursorColor: AppColors()
                                                          .borderColor,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 16,
                                                                left: 20,
                                                                bottom: 10,
                                                                top: 10),
                                                        hintStyle: TextStyles
                                                            .formLabelTextStyle,
                                                        hintText:
                                                            'Type a message',
                                                        border:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          gapPadding: 0,
                                                          borderSide: BorderSide(
                                                              color: AppColors()
                                                                  .borderColor),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          gapPadding: 0,
                                                          borderSide: BorderSide(
                                                              color: AppColors()
                                                                  .borderColor),
                                                        ),
                                                      ),
                                                      onChanged: (_) {
                                                        if (textController
                                                            .text.isEmpty) {
                                                          sendStopTypingEvent(
                                                              chat.id);
                                                        } else {
                                                          sendTypingEvent(
                                                              chat.id);
                                                        }
                                                      },
                                                      onEditingComplete: () {
                                                        sendMessage(
                                                            textController
                                                                .text);
                                                      },
                                                      onSubmitted: (_) {
                                                        sendStopTypingEvent(
                                                            chat.id);
                                                        sendMessage(
                                                            textController
                                                                .text);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          splashRadius: 20,
                                          icon: Icon(Icons.send,
                                              color: AppColors().iconColor),
                                          onPressed: () {
                                            if (textController
                                                .text.isNotEmpty) {
                                              sendMessage(textController.text);
                                              // textController.clear();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ));
  }
}
