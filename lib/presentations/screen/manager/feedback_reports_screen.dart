import 'dart:developer';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utills/dimensions.dart';
import '../../controllers/user/user_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FeedbackReportsScreen extends StatefulWidget {
  const FeedbackReportsScreen({
    super.key,
  });

  @override
  State<FeedbackReportsScreen> createState() => _FeedbackReportsScreenState();
}

class _FeedbackReportsScreenState extends State<FeedbackReportsScreen> {
  // late UserModel userModel;
  // @override
  // void initState() {
  //   //getIt<PetCubit>().getWaitingPets(context);
  //   init();
  //   super.initState();
  // }

  // void init() {
  //   final user = getIt<SharedPreferences>().getString('user') ?? '';
  //   // final user = shared.;
  //   userModel = UserModel.fromjson(jsonDecode(user));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>()..getFeedbackReports(context),
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
          title: Text(AppLocalizations.of(context)!.feedback_reports,
              style: TextStyles.titleTextStyle),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is LoadingFeedbackReportsState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ),
              );
            }
            if (state is LoadedFeedbackReportsState) {
              return state.reports.isEmpty
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
                              if (isManager)
                                SlidableAction(
                                  onPressed: (BuildContext scontext) {
                                    BlocProvider.of<UserCubit>(context)
                                        .removefeedbackReport(
                                            context,
                                            state.reports,
                                            state.reports[index].id);
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
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
                              leading: Icon(Icons.feedback_outlined,
                                  color: AppColors().iconColor),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.reports[index].content,
                                    style: TextStyles.textFormFieldWidgetStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    state.reports[index].date.toString(),
                                    style: TextStyles.textFormFieldWidgetStyle,
                                  ),
                                ],
                              ),
                              trailing:
                                  state.reports[index].user.picture.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundColor: AppColors()
                                              .backgroundColorCircleAvatar,
                                          backgroundImage:
                                              CachedNetworkImageProvider(state
                                                  .reports[index].user.picture),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: AppColors()
                                              .backgroundColorCircleAvatar,
                                          backgroundImage: const AssetImage(
                                              "assets/profile.png"),
                                        )),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: state.reports.length,
                    );
            }
            if (state is ErrorWaitingPetsState) {
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
  }
}
