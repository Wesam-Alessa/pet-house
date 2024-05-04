import 'dart:convert';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/utills/dimensions.dart';
import '../../../data/models/parameters/item_deletion_report_parameters.dart';
import '../../controllers/pet_foods/pet_foods_cubit.dart';
import '../../controllers/user/user_cubit.dart';
import '../../widgets/foods/food_card_widget.dart';

class WaitingFoodsScreen extends StatefulWidget {
  const WaitingFoodsScreen({
    super.key,
  });

  @override
  State<WaitingFoodsScreen> createState() => _WaitingFoodsScreenState();
}

class _WaitingFoodsScreenState extends State<WaitingFoodsScreen> {
  late UserModel userModel;
  @override
  void initState() {
    //getIt<PetCubit>().getWaitingPets(context);
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
    return BlocProvider(
      create: (context) => getIt.get<PetFoodsCubit>()..getWaitingFoods(context),
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
          title: Text(AppLocalizations.of(context)!.waiting_foods,
              //'Waiting Pets',
              style: TextStyles.titleTextStyle),
        ),
        body: BlocBuilder<PetFoodsCubit, PetFoodsState>(
          builder: (context, state) {
            if (state is LoadingWaitingFoodsState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ),
              );
            }
            if (state is LoadedWaitingFoodsState) {
              return state.waitingFoods.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_Items,
                        // 'No Items',
                        style: TextStyles.labelTextStyle,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (lcontext, index) {
                        return Column(
                          children: [
                            FoodCardWidget(
                                food: state.waitingFoods[index], index: index),
                            if (isAdmin && state.waitingFoods[index].waiting)
                              SizedBox(width: Dimensions.width10),
                            if (isAdmin && state.waitingFoods[index].waiting)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          maximumSize: Size(
                                              Dimensions.width30 * 2.5,
                                              Dimensions.height30 * 1.5),
                                          backgroundColor:
                                              AppColors().primaryColorLight),
                                      onPressed: () {
                                        BlocProvider.of<PetFoodsCubit>(context,
                                                listen: false)
                                            .publishWaitingFoods(context,
                                                state.waitingFoods[index].id);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .publishing,
                                            //'Publishing',
                                            style: TextStyles.formLabelTextStyle
                                                .copyWith(color: Colors.white),
                                          ),
                                          SizedBox(
                                              width: Dimensions.width10 / 2),
                                          const Icon(
                                            Icons.publish_outlined,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          maximumSize: Size(
                                              Dimensions.width30 * 2.5,
                                              Dimensions.height30 * 1.5),
                                          backgroundColor:
                                              AppColors().primaryColorLight),
                                      onPressed: () {
                                        BlocProvider.of<PetFoodsCubit>(context,
                                                listen: false)
                                            .postFoodReportedDeletionReport(
                                                context,
                                                state.waitingFoods,
                                                ItemDeletionReportParameters(
                                                  itemId: state
                                                      .waitingFoods[index].id,
                                                  ownerId: state
                                                      .waitingFoods[index]
                                                      .seller
                                                      .id,
                                                  adminId: userModel.id,
                                                  content: AppConst
                                                      .contentItemDeletionReport,
                                                    type:'food'

                                                ),

                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .report,
                                            //'Report',
                                            style: TextStyles.formLabelTextStyle
                                                .copyWith(color: Colors.white),
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
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: state.waitingFoods.length,
                    );
            }
            if (state is ErrorWaitingFoodsState) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.error_something_wrong,
                  //'Error Loading Waiting Pet List',
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
