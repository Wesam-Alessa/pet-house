import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/pet_card_widget.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/foods/food_card_widget.dart';
import '../widgets/tools/tool_card_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>()..getFavourites(context),
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
          title: Text(AppLocalizations.of(context)!.favorites,
              //"Favorites",
              style: TextStyles.titleTextStyle),
        ),
        body: BlocConsumer<UserCubit, UserState>(
            listener: (lcontext, state) {},
            buildWhen: (previous, current) => previous != current,
            builder: (lcontext, state) {
              if (state is LoadingFavouritesState) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors().circularProgressIndicatorColor,
                ));
              }
              if (state is LoadedFavouritesState) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: SizedBox(
                      height: Dimensions.screenHeight,
                      width: double.infinity,
                      child: state.items.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: state.items.length,
                              itemBuilder: (lcontext, index) {
                                return Stack(
                                  children: [
                                    if (state.items[index].type == 'pet')
                                      PetCardWidget(
                                          pet: state.items[index].value,
                                          index: index),
                                    if (state.items[index].type == 'tool')
                                      ToolCardWidget(
                                          tool: state.items[index].value,
                                          index: index),
                                    if (state.items[index].type == 'food')
                                      FoodCardWidget(
                                          food: state.items[index].value,
                                          index: index),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<UserCubit>(lcontext,
                                                    listen: false)
                                                .removeFavItem(
                                                    lcontext,
                                                    state.items[index].value.id,
                                                    state.items[index].type);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        ))
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 15),
                            )
                          : Center(
                              child: Text(
                                AppLocalizations.of(context)!.no_Items,
                                //"No Favorite Item",
                                style: TextStyles.cardSubTitleTextStyle2
                                    .copyWith(color: Colors.black),
                              ),
                            )),
                );
              }
              return Container();
            }),
      ),
    );
  }
}
