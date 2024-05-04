import 'dart:convert';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/presentations/controllers/tools/tools_cubit.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_house/presentations/widgets/tools/tool_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/services/service_locator.dart';
import '../../../data/models/parameters/item_deletion_report_parameters.dart';
import '../../../data/models/user_model.dart';
import '../../controllers/pet/pet_cubit.dart';
import '../../controllers/pet_foods/pet_foods_cubit.dart';
import '../../widgets/foods/food_card_widget.dart';

class ReportedItemsScreen extends StatefulWidget {
  const ReportedItemsScreen({super.key});

  @override
  State<ReportedItemsScreen> createState() => _ReportedItemsScreenState();
}

class _ReportedItemsScreenState extends State<ReportedItemsScreen> {
  late UserModel userModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    final user = getIt<SharedPreferences>().getString('user') ?? '';
    // final user = shared.;
    userModel = UserModel.fromjson(jsonDecode(user));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) =>
                getIt.get<PetCubit>()..getPetsReported(context),
          ),
          BlocProvider(
            create: (BuildContext context) =>
                getIt.get<ToolsCubit>()..getToolsReported(context),
          ),
          BlocProvider(
            create: (BuildContext context) =>
            getIt.get<PetFoodsCubit>()..getFoodsReported(context),
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors().backgroundColorScaffold,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.pets,
                  color: Theme.of(context).iconTheme.color,
                )),
                Tab(
                    icon: Icon(
                  Icons.construction_outlined,
                  color: Theme.of(context).iconTheme.color,
                )),
                Tab(
                    icon: Icon(
                  Icons.restaurant_menu_outlined,
                  color: Theme.of(context).iconTheme.color,
                )),
              ],
            ),
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
            title: Text(
              AppLocalizations.of(context)!.reported_items_list,
              //'Reported Pets',
              style: TextStyles.titleTextStyle,
            ),
          ),
          body: TabBarView(
            children: [
              BlocBuilder<PetCubit, PetState>(
                builder: (context, state) {
                  if (state is LoadingPetsReportedState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors().circularProgressIndicatorColor,
                      ),
                    );
                  }
                  if (state is LoadedPetsReportedState) {
                    return state.petsReported.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_Items,
                              style: TextStyles.labelTextStyle,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (lcontext, index) {
                              return Column(
                                children: [
                                  PetCardWidget(
                                      pet: state.petsReported[index],
                                      index: index),
                                  if (isAdmin &&
                                      state.petsReported[index].waiting)
                                    SizedBox(width: Dimensions.width10),
                                  if (isAdmin &&
                                      state.petsReported[index].reports
                                          .isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                maximumSize: Size(
                                                    Dimensions.width30 * 2.5,
                                                    Dimensions.height30 * 1.5),
                                                backgroundColor: AppColors()
                                                    .primaryColorLight),
                                            onPressed: () {
                                              BlocProvider.of<PetCubit>(context,
                                                      listen: false)
                                                  .removePetReports(
                                                      context,
                                                      state.petsReported,
                                                      state.petsReported[index]
                                                          .id);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .c_Rports,
                                                  //'C/Rports',
                                                  style: TextStyles
                                                      .formLabelTextStyle
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                                // SizedBox(
                                                //     width:
                                                //         Dimensions.width10 / 2),
                                                const Icon(
                                                  Icons.clean_hands_outlined,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                maximumSize: Size(
                                                    Dimensions.width30 * 2.5,
                                                    Dimensions.height30 * 1.5),
                                                backgroundColor: AppColors()
                                                    .primaryColorLight),
                                            onPressed: () {
                                              BlocProvider.of<PetCubit>(context,
                                                      listen: false)
                                                  .postPetReportedDeletionReport(
                                                      context,
                                                      state.petsReported,
                                                      ItemDeletionReportParameters(
                                                          itemId: state
                                                              .petsReported[
                                                                  index]
                                                              .id,
                                                          ownerId: state
                                                              .petsReported[
                                                                  index]
                                                              .seller
                                                              .id,
                                                          adminId: userModel.id,
                                                          content: AppConst
                                                              .contentItemDeletionReport,
                                                          type: 'pet'));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .d_Report,
                                                  //'D/Report',
                                                  style: TextStyles
                                                      .formLabelTextStyle
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                                // SizedBox(
                                                //     width:
                                                //          2),
                                                const Icon(
                                                  Icons.delete_sweep_rounded,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: state.petsReported.length,
                          );
                  }
                  if (state is ErrorPetsReportedState) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.error_something_wrong,
                        //'Error Loading Pets Reported List'
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<ToolsCubit, ToolsState>(
                builder: (context, state) {
                  if (state is LoadingToolsReportedState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors().circularProgressIndicatorColor,
                      ),
                    );
                  }
                  if (state is LoadedToolsReportedState) {
                    return state.toolsReported.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_Items,
                              style: TextStyles.labelTextStyle,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (lcontext, index) {
                              return Column(
                                children: [
                                  ToolCardWidget(
                                      tool: state.toolsReported[index],
                                      index: index),
                                  if (isAdmin &&
                                      state.toolsReported[index].waiting)
                                    SizedBox(width: Dimensions.width10),
                                  if (isAdmin &&
                                      state.toolsReported[index].reports
                                          .isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                maximumSize: Size(
                                                    Dimensions.width30 * 2.5,
                                                    Dimensions.height30 * 1.5),
                                                backgroundColor: AppColors()
                                                    .primaryColorLight),
                                            onPressed: () {
                                              BlocProvider.of<ToolsCubit>(
                                                      context,
                                                      listen: false)
                                                  .removeToolReports(
                                                      context,
                                                      state.toolsReported,
                                                      state.toolsReported[index]
                                                          .id);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .c_Rports,
                                                  //'C/Rports',
                                                  style: TextStyles
                                                      .formLabelTextStyle
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                                // SizedBox(
                                                //     width:
                                                //         Dimensions.width10 / 2),
                                                const Icon(
                                                  Icons.clean_hands_outlined,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                maximumSize: Size(
                                                    Dimensions.width30 * 2.5,
                                                    Dimensions.height30 * 1.5),
                                                backgroundColor: AppColors()
                                                    .primaryColorLight),
                                            onPressed: () {
                                              BlocProvider.of<ToolsCubit>(context,
                                                  listen: false)
                                                  .postToolReportedDeletionReport(
                                                  context,
                                                  state.toolsReported,
                                                  ItemDeletionReportParameters(
                                                      itemId: state
                                                          .toolsReported[index].id,
                                                      ownerId: state
                                                          .toolsReported[index]
                                                          .seller
                                                          .id,
                                                      adminId: userModel.id,
                                                      content: AppConst
                                                          .contentItemDeletionReport,
                                                      type:'tool'
                                                  ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .d_Report,
                                                  //'D/Report',
                                                  style: TextStyles
                                                      .formLabelTextStyle
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                                // SizedBox(
                                                //     width:
                                                //         Dimensions.width10 / 2),
                                                const Icon(
                                                  Icons.delete_sweep_rounded,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: state.toolsReported.length,
                          );
                  }
                  if (state is ErrorToolsReportedState) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.error_something_wrong,
                        //'Error Loading Pets Reported List'
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<PetFoodsCubit, PetFoodsState>(
                builder: (context, state) {
                  if (state is LoadingFoodsReportedState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors().circularProgressIndicatorColor,
                      ),
                    );
                  }
                  if (state is LoadedFoodsReportedState) {
                    return state.foodsReported.isEmpty
                        ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_Items,
                        style: TextStyles.labelTextStyle,
                      ),
                    )
                        : ListView.separated(
                      itemBuilder: (lcontext, index) {
                        return Column(
                          children: [
                            FoodCardWidget(
                                food: state.foodsReported[index],
                                index: index),
                            if (isAdmin &&
                                state.foodsReported[index].waiting)
                              SizedBox(width: Dimensions.width10),
                            if (isAdmin &&
                                state.foodsReported[index].reports
                                    .isNotEmpty)
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          maximumSize: Size(
                                              Dimensions.width30 * 2.5,
                                              Dimensions.height30 * 1.5),
                                          backgroundColor: AppColors()
                                              .primaryColorLight),
                                      onPressed: () {
                                        BlocProvider.of<PetFoodsCubit>(
                                            context,
                                            listen: false)
                                            .removeFoodReports(
                                            context,
                                            state.foodsReported,
                                            state.foodsReported[index]
                                                .id);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .c_Rports,
                                            //'C/Rports',
                                            style: TextStyles
                                                .formLabelTextStyle
                                                .copyWith(
                                                color: Colors.white),
                                          ),
                                          // SizedBox(
                                          //     width:
                                          //     Dimensions.width10 / 2),
                                          const Icon(
                                            Icons.clean_hands_outlined,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          maximumSize: Size(
                                              Dimensions.width30 * 2.5,
                                              Dimensions.height30 * 1.5),
                                          backgroundColor: AppColors()
                                              .primaryColorLight),
                                      onPressed: () {
                                        BlocProvider.of<PetFoodsCubit>(context,
                                            listen: false)
                                            .postFoodReportedDeletionReport(
                                            context,
                                            state.foodsReported,
                                            ItemDeletionReportParameters(
                                                itemId: state
                                                    .foodsReported[index].id,
                                                ownerId: state
                                                    .foodsReported[index]
                                                    .seller
                                                    .id,
                                                adminId: userModel.id,
                                                content: AppConst
                                                    .contentItemDeletionReport,
                                                type:'tool'
                                            ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .d_Report,
                                            //'D/Report',
                                            style: TextStyles
                                                .formLabelTextStyle
                                                .copyWith(
                                                color: Colors.white),
                                          ),
                                          // SizedBox(
                                          //     width:
                                          //     Dimensions.width10 / 2),
                                          const Icon(
                                            Icons.delete_sweep_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                      itemCount: state.foodsReported.length,
                    );
                  }
                  if (state is ErrorFoodsReportedState) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.error_something_wrong,
                        //'Error Loading Pets Reported List'
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
