import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/pet_foods/pet_foods_cubit.dart';
import '../../widgets/foods/food_card_widget.dart';

class FoodsCategoryScreen extends StatefulWidget {
  final String catName;

  const FoodsCategoryScreen({Key? key, required this.catName})
      : super(key: key);

  @override
  State<FoodsCategoryScreen> createState() => _FoodsCategoryScreenState();
}

class _FoodsCategoryScreenState extends State<FoodsCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            //pushReplacementNamed(context, HOME_SCREEN),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors().iconColor,
            ),
          ),
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            widget.catName,
            style: TextStyles.titleTextStyle,
          ),
        ),
        body: BlocBuilder<PetFoodsCubit, PetFoodsState>(
            bloc: getIt.get<PetFoodsCubit>()..getFoods(context, widget.catName),
            builder: (context, state) {
              if (state is LoadingFoodsState) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ));
              }
              if (state is LoadedFoodsState) {
                return state.foods.isNotEmpty
                    ? Directionality(
                        textDirection: TextDirection.ltr,
                        child: SizedBox(
                          height: Dimensions.screenHeight * 0.67,
                          width: double.infinity,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: state.foods.length,
                            itemBuilder: (context, index) {
                              return FoodCardWidget(
                                index: index,
                                food: state.foods[index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 15),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_Items,
                          //"No Items ",
                          style: TextStyles.cardSubTitleTextStyle2,
                        ),
                      );
              } else {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.not_item_found,
                    // "No Items Founded ",
                    style: TextStyles.cardSubTitleTextStyle2
                        .copyWith(color: Colors.black),
                  ),
                );
              }
            }));
  }
}
