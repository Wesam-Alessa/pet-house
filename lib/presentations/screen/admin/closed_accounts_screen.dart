import 'dart:developer';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/utills/dimensions.dart';
import '../../controllers/user/user_cubit.dart';

class ClosedAccountsScreen extends StatefulWidget {
  const ClosedAccountsScreen({Key? key}) : super(key: key);

  @override
  State<ClosedAccountsScreen> createState() => _ClosedAccountsScreen();
}

class _ClosedAccountsScreen extends State<ClosedAccountsScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>()..getClosedAccounts(context),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors().iconColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppLocalizations.of(context)!.closed_accounts,
              style: TextStyles.titleTextStyle),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is LoadingClosedAccountsListState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ),
              );
            }
            if (state is LoadedClosedAccountsListState) {
              return state.list.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_Items,
                        style: TextStyles.labelTextStyle,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (lcontext, index) {
                        return Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              if (isManager || isAdmin)
                                SlidableAction(
                                  onPressed: (BuildContext scontext) {
                                    log(state.list[index].id.toString());
                                    BlocProvider.of<UserCubit>(context)
                                        .reActiveClosedAccount(
                                            context,
                                            state.list,
                                            state.list[index].id,
                                            state.list[index]);
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 12, 148, 48),
                                  foregroundColor: Colors.white,
                                  icon: Icons.manage_accounts_rounded,
                                  label:
                                      AppLocalizations.of(context)!.re_Active,
                                ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.5, color: AppColors().borderColor),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius10 / 2),
                            ),
                            leading: state.list[index].picture.isEmpty
                                ? CircleAvatar(
                                    backgroundColor:
                                        AppColors().backgroundColorCircleAvatar,
                                    backgroundImage:
                                        const AssetImage("assets/profile.png"),
                                  )
                                : CircleAvatar(
                                    backgroundColor:
                                        AppColors().backgroundColorCircleAvatar,
                                    backgroundImage: CachedNetworkImageProvider(
                                        state.list[index].picture),
                                  ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.list[index].name,
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.list[index].address,
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.is_admin} :  ${state.list[index].isAdmin}",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.is_manager} :  ${state.list[index].isManager}",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.reason} :  ${state.list[index].whyDisabled}",
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)!.close_by,
                                  style: TextStyles.textFormFieldWidgetStyle,
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.5,
                                        color: AppColors().borderColor),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius10 / 2),
                                  ),
                                  leading: state.list[index].disabledBy!.picture
                                          .isEmpty
                                      ? CircleAvatar(
                                          backgroundColor: AppColors()
                                              .backgroundColorCircleAvatar,
                                          backgroundImage: const AssetImage(
                                              "assets/profile.png"),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: AppColors()
                                              .backgroundColorCircleAvatar,
                                          backgroundImage:
                                              CachedNetworkImageProvider(state
                                                  .list[index]
                                                  .disabledBy!
                                                  .picture),
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.list[index].disabledBy!.name,
                                        style:
                                            TextStyles.textFormFieldWidgetStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        state.list[index].address,
                                        style:
                                            TextStyles.textFormFieldWidgetStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${AppLocalizations.of(context)!.is_admin} :  ${state.list[index].disabledBy!.isAdmin}",
                                        style:
                                            TextStyles.textFormFieldWidgetStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${AppLocalizations.of(context)!.is_manager} :  ${state.list[index].disabledBy!.isManager}",
                                        style:
                                            TextStyles.textFormFieldWidgetStyle,
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(Icons.account_circle_outlined,
                                      color: AppColors().iconColor),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                            trailing: Icon(Icons.no_accounts_outlined,
                                color: AppColors().iconColor),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: state.list.length,
                    );
            }
            if (state is ErrorClosedAccountsListState) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.error_something_wrong,
                  style: TextStyles.labelTextStyle,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
    // return BlocProvider(
    //   create: (BuildContext context) => getIt.get<UserCubit>()..getClosedAccounts(context, [], ''),
    //   child: Scaffold(
    //     backgroundColor: AppColors().backgroundColorScaffold,
    //     body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
    //       return SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             SizedBox(
    //               height: Dimensions.height30,
    //             ),
    //             Row(
    //               children: [
    //                 SizedBox(
    //                   width: Dimensions.width10 / 2,
    //                 ),
    //                 IconButton(
    //                   onPressed: () {
    //                     FocusScope.of(context).unfocus();
    //                     Future.delayed(const Duration(milliseconds: 300), () {
    //                       Navigator.pop(context);
    //                     });
    //                   },
    //                   icon: Icon(
    //                     Icons.arrow_back_ios,
    //                     color: AppColors().iconColor,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: Dimensions.width30 * 1.2,
    //                 ),
    //                 Text(AppLocalizations.of(context)!.closed_accounts,
    //                     style: TextStyles.titleTextStyle),
    //               ],
    //             ),
    //             // Padding(
    //             //   padding: const EdgeInsets.all(8.0),
    //             //   child: TextFormField(
    //             //     controller: controller,
    //             //     style: TextStyles.textFormFieldWidgetStyle,
    //             //     decoration: InputDecoration(
    //             //       border: const OutlineInputBorder(),
    //             //       labelText:
    //             //           AppLocalizations.of(context)!.find_those_responsible,
    //             //       labelStyle: TextStyles.formLabelTextStyle,
    //             //       hintStyle: TextStyles.formLabelTextStyle,
    //             //       focusedBorder: OutlineInputBorder(
    //             //         borderSide: BorderSide(
    //             //             width: 1.5, color: AppColors().borderColor),
    //             //       ),
    //             //       enabledBorder: OutlineInputBorder(
    //             //         borderSide: BorderSide(
    //             //             width: 1.5, color: AppColors().borderColor),
    //             //       ),
    //             //     ),
    //             //     onChanged: (value) {
    //             //       if (value.isNotEmpty) {
    //             //         BlocProvider.of<UserCubit>(context)
    //             //             .searchUsers(context: context, text: value);
    //             //       }
    //             //       if (value.isEmpty) {
    //             //         BlocProvider.of<UserCubit>(context).clearSearchUsers();
    //             //       }
    //             //     },
    //             //   ),
    //             // ),
    //             if (state is LoadingClosedAccountsListState)
    //               Center(
    //                   child: CircularProgressIndicator(
    //                 color: AppColors().circularProgressIndicatorColor,
    //               )),
    //             if (state is LoadedClosedAccountsListState && state.list.isNotEmpty)
    //               SizedBox(
    //                 height: Dimensions.screenHeight - 200,
    //                 width: double.infinity,
    //                 child: ListView.separated(
    //                   padding: const EdgeInsets.symmetric(
    //                       vertical: 10, horizontal: 8),
    //                   itemCount: state.list.length,
    //                   itemBuilder: (context, index) {
    //                     return UserCardWidget(
    //                       index: index,
    //                       closedAccounts:true,
    //                       user: state.list[index],
    //                     );
    //                   },
    //                   separatorBuilder: (BuildContext context, int index) =>
    //                       const SizedBox(height: 15),
    //                 ),
    //               ),
    //             if (state is LoadedClosedAccountsListState && state.list.isEmpty)
    //               Center(
    //                 child: Text(AppLocalizations.of(context)!.not_item_found,
    //                     style: TextStyles.cardSubTitleTextStyle2),
    //               ),
    //           ],
    //         ),
    //       );
    //     }),
    //   ),
    // );
  }
}
