import 'dart:convert';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/conversation/chat_widget.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> online = [];
  String uid = '';
  @override
  void initState() {
    SharedPreferences shared = getIt();
    uid = jsonDecode(shared.getString('user') ?? "")['_id'];
    online = getIt.get<List<dynamic>>();
    super.initState();
  }

  @override
  void dispose() {
    online.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>()..getChats(context),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors().iconColor,
            ),
          ),
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0.0,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.your_Chats,
              
              style: TextStyles.titleTextStyle),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LoadingChatsState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ),
              );
            }
            if (state is ErrorLoadingChatsState) {
              return Center(
                child: Text(AppLocalizations.of(context)!.no_Items,
                    //"Error Loading Chats ",
                    style: TextStyles.cardSubTitleTextStyle2),
              );
            }
            if (state is LoadedChatsState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: state.chats
                        .map((e) => Column(
                              children: [
                                ChatWidget(
                                    chat: e,
                                    online: e.users[0].id == uid
                                        ? online.contains(e.users[1].id)
                                        : online.contains(e.users[0].id)),
                                state.chats.indexOf(e) != state.chats.length - 1
                                    ? Divider(
                                        color: Colors.grey.shade300,
                                        indent: 80,
                                        height: 1,
                                        endIndent: 16,
                                      )
                                    : const SizedBox(),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
            //return

            //  FutureBuilder<List<GetChatModel>>(
            //   //future: getIt.get<UserCubit>().getChats(context),
            //   builder: (context, snapshot) {

            //   },
            // );
          },
        ),
      ),
    );
  }
}
