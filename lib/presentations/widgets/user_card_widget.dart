import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/data/models/parameters/change_user_status_parameters.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/error/show_custom_snackbar.dart';
import '../../core/services/service_locator.dart';
import '../../core/utills/dimensions.dart';
import '../../data/models/user_model.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final int index;
  final bool closedAccounts;
  const UserCardWidget(
      {Key? key,
      required this.user,
      required this.index,
      required this.closedAccounts})
      : super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: AppColors().borderColor),
            borderRadius: BorderRadius.circular(Dimensions.radius10 / 2),
          ),
          leading: user.picture.isEmpty
              ? CircleAvatar(
                  backgroundColor: AppColors().backgroundColorCircleAvatar,
                  backgroundImage: const AssetImage("assets/profile.png"),
                )
              : CircleAvatar(
                  backgroundColor: AppColors().backgroundColorCircleAvatar,
                  backgroundImage: CachedNetworkImageProvider(user.picture),
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyles.textFormFieldWidgetStyle,
              ),
              const SizedBox(height: 10),
              Text(
                user.address,
                style: TextStyles.textFormFieldWidgetStyle,
              ),
              const SizedBox(height: 10),
              Text(
                "${AppLocalizations.of(context)!.is_admin} :  ${user.isAdmin}",
                style: TextStyles.textFormFieldWidgetStyle,
              ),
              const SizedBox(height: 10),
              Text(
                "${AppLocalizations.of(context)!.is_manager} :  ${user.isManager}",
                style: TextStyles.textFormFieldWidgetStyle,
              ),
            ],
          ),
          trailing:
              Icon(Icons.account_circle_outlined, color: AppColors().iconColor),
          onTap: () {
            TextEditingController label = TextEditingController();
            editUserStatus(context, user.isAdmin, user.isManager, user.disabled,
                user.id, label);
          },
        ));
  }

  editUserStatus(
    mcontext,
    bool isadmin,
    bool ismanager,
    bool disable,
    String uid,
    TextEditingController label,
  ) {
    bool admin = isadmin;
    //bool manager = ismanager;
    bool disabled = disable;
    showDialog(
      context: mcontext,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, localSetState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(mcontext)!.update_user_status),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!closedAccounts)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${AppLocalizations.of(mcontext)!.is_admin} :  $admin"),
                        Switch(
                          value: admin,
                          onChanged: (value) async {
                            admin = value;
                            localSetState(() {});
                          },
                          activeTrackColor: AppColors().primaryColorLight,
                          activeColor: Colors.white38,
                        ),
                      ],
                    ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //         "${AppLocalizations.of(mcontext)!.is_manager} :  $manager"),
                  //     Switch(
                  //       value: manager,
                  //       onChanged: (value) async {
                  //         manager = value;
                  //         localSetState(() {});
                  //       },
                  //       activeTrackColor: AppColors().primaryColorLight,
                  //       activeColor: Colors.white38,
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${AppLocalizations.of(mcontext)!.disabled} :  $disabled"),
                      Switch(
                        value: disabled,
                        onChanged: (value) async {
                          disabled = value;
                          localSetState(() {});
                        },
                        activeTrackColor: AppColors().primaryColorLight,
                        activeColor: Colors.white38,
                      ),
                    ],
                  ),
                  if (disabled)
                    TextFormField(
                      controller: label,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(mcontext)!.write_the_reason),
                    ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    label.clear();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.update),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (disabled && label.text.isEmpty) {
                      showError(
                          mcontext,
                          AppLocalizations.of(mcontext)!
                              .error_write_the_reason);
                      return;
                    }
                    
                    getIt.get<UserCubit>().changeUserStatusByManager(
                        mcontext,
                        ChangeUserStatusByManagerParameters(
                            uid: uid,
                            whyDisabled: label.text,
                            isAdmin: admin,
                            isManager: ismanager,
                            disabled: disabled));

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }
}
