import 'dart:developer';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/data/models/parameters/item_deletion_report_parameters.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/pet_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constant/text_style.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/utills/dimensions.dart';
import '../../widgets/foods/food_card_widget.dart';
import '../../widgets/tools/tool_card_widget.dart';

class ItemDeletionReportsScreen extends StatefulWidget {
  const ItemDeletionReportsScreen({super.key});

  @override
  State<ItemDeletionReportsScreen> createState() =>
      _ItemDeletionReportsScreenState();
}

class _ItemDeletionReportsScreenState extends State<ItemDeletionReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCubit>()..getItemDeletionReports(context),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors().iconColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppLocalizations.of(context)!.item_Deletion_Reports,
              //'Item Deletion Reports',
              style: TextStyles.titleTextStyle),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is LoadingItemDeletionReports) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LoadedItemDeletionReports) {
              return state.reports.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_Items,
                        style: TextStyles.labelTextStyle,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (lcontext, index) {
                        return Container(
                          margin: EdgeInsets.all(Dimensions.width10 / 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade700, width: 1.5),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius10),
                          ),
                          child: Column(
                            children: [
                              if (state.reports[index].item.id.isNotEmpty && state.reports[index].type == 'pet')
                                PetCardWidget(
                                    pet: state.reports[index].item,
                                    index: index),
                              if (state.reports[index].item.id.isNotEmpty && state.reports[index].type == 'tool')
                                ToolCardWidget(
                                    tool: state.reports[index].item,
                                    index: index),
                              if (state.reports[index].item.id.isNotEmpty && state.reports[index].type == 'food')
                                FoodCardWidget(
                                    food: state.reports[index].item,
                                    index: index),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 8.0, left: 8.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius10 / 2),
                                  ),
                                  leading: state
                                          .reports[index].owner.picture.isEmpty
                                      ? CircleAvatar(
                                          radius: Dimensions.radius20,
                                          backgroundImage: const AssetImage(
                                              "assets/profile.png"),
                                        )
                                      : CircleAvatar(
                                          radius: Dimensions.radius20,
                                          backgroundImage:
                                              CachedNetworkImageProvider(state
                                                  .reports[index]
                                                  .owner
                                                  .picture),
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(state.reports[index].owner.name,
                                          style: TextStyles.labelTextStyle),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .owner_this_item,
                                          //"Owner this item",
                                          style:
                                              TextStyles.descriptionTextStyle),
                                    ],
                                  ),
                                  trailing: Icon(
                                      Icons.arrow_circle_right_outlined,
                                      color: AppColors().primaryColorLight),
                                  // onTap: () => Navigator.pushNamed(
                                  //     context, REPORTED_PETS_SCREEN),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 8.0, left: 8.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius10 / 2),
                                  ),
                                  leading: state
                                          .reports[index].admin.picture.isEmpty
                                      ? CircleAvatar(
                                          radius: Dimensions.radius20,
                                          backgroundImage: const AssetImage(
                                              "assets/profile.png"),
                                        )
                                      : CircleAvatar(
                                          radius: Dimensions.radius20,
                                          backgroundImage:
                                              CachedNetworkImageProvider(state
                                                  .reports[index]
                                                  .admin
                                                  .picture),
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(state.reports[index].admin.name,
                                          style: TextStyles.labelTextStyle),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .admin_reported_this_item,
                                          style:
                                              TextStyles.descriptionTextStyle),
                                    ],
                                  ),
                                  trailing: Icon(
                                      Icons.arrow_circle_right_outlined,
                                      color: AppColors().primaryColorLight),
                                  // onTap: () => Navigator.pushNamed(
                                  //     context, REPORTED_PETS_SCREEN),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(state.reports[index].content,
                                    style: TextStyles.labelTextStyle),
                              ),
                              if (isManager)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //         maximumSize: Size(
                                    //             Dimensions.width30 * 2.5,
                                    //             Dimensions.height30 * 1.5),
                                    //         backgroundColor:
                                    //             AppColors.primaryColor),
                                    //     onPressed: () {
                                    //       // BlocProvider.of<PetCubit>(context,
                                    //       //         listen: false)
                                    //       //     .removePetReports(
                                    //       //         context,
                                    //       //         state.petsReported,
                                    //       //         state.petsReported[index].id);
                                    //     },
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         Text(
                                    //           'Ignore',
                                    //           style: TextStyles
                                    //               .formLabelTextStyle
                                    //               .copyWith(
                                    //                   color: Colors.white),
                                    //         ),
                                    //         SizedBox(
                                    //             width: Dimensions.width10 / 2),
                                    //         const Icon(
                                    //           Icons.clear_all_rounded,
                                    //           color: Colors.white,
                                    //         ),
                                    //       ],
                                    //     )),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            maximumSize: Size(
                                                Dimensions.width30 * 2.5,
                                                Dimensions.height30 * 1.5),
                                            backgroundColor:
                                                AppColors().primaryColorLight),
                                        onPressed: () {
                                          log(state.reports[index].owner.id
                                              .toString());
                                          BlocProvider.of<UserCubit>(context,
                                                  listen: false)
                                              .deleteItemDeletionReport(
                                            context,
                                            DeleteItemDeletionReportParameters(
                                              reportID:
                                                  state.reports[index].reportID,
                                              publisherID:
                                                  state.reports[index].owner.id,
                                            ),
                                            state.reports,
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .delete,
                                              //'Delete',
                                              style: TextStyles
                                                  .formLabelTextStyle
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            SizedBox(
                                                width: Dimensions.width10 / 2),
                                            const Icon(
                                              Icons.delete_sweep_rounded,
                                              color: Colors.white,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: state.reports.length,
                    );
            }
            if (state is ErrorLoadingItemDeletionReports) {
              return Center(
                child:
                    Text(AppLocalizations.of(context)!.error_something_wrong),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
