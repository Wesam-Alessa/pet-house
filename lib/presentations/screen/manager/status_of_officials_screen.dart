import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/presentations/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utills/dimensions.dart';
import '../../controllers/user/user_cubit.dart';

class StatusOfOfficialsScreen extends StatefulWidget {
  const StatusOfOfficialsScreen({Key? key}) : super(key: key);

  @override
  State<StatusOfOfficialsScreen> createState() => _StatusOfOfficialsScreen();
}

class _StatusOfOfficialsScreen extends State<StatusOfOfficialsScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt.get<UserCubit>(),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.height30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Dimensions.width10 / 2,
                    ),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors().iconColor,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.width30 * 1.2,
                    ),
                    Text(AppLocalizations.of(context)!.administrators_screen,
                        style: TextStyles.titleTextStyle),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller,
                    style: TextStyles.textFormFieldWidgetStyle,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context)!.find_those_responsible,
                      labelStyle: TextStyles.formLabelTextStyle,
                      hintStyle: TextStyles.formLabelTextStyle,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        BlocProvider.of<UserCubit>(context)
                            .searchUsers(context: context, text: value);
                      }
                      if (value.isEmpty) {
                        BlocProvider.of<UserCubit>(context).clearSearchUsers();
                      }
                    },
                  ),
                ),
                if (state is LoadingSearchUsersState)
                  Center(
                      child: CircularProgressIndicator(
                    color: AppColors().circularProgressIndicatorColor,
                  )),
                if (state is LoadedSearchUsersState && state.search.isNotEmpty)
                  SizedBox(
                    height: Dimensions.screenHeight - 200,
                    width: double.infinity,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      itemCount: state.search.length,
                      itemBuilder: (context, index) {
                        return UserCardWidget(
                          index: index,
                          closedAccounts: false,
                          user: state.search[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 15),
                    ),
                  ),
                if (state is LoadedSearchUsersState && state.search.isEmpty)
                  Center(
                    child: Text(AppLocalizations.of(context)!.not_item_found,
                        style: TextStyles.cardSubTitleTextStyle2),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
