import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utills/dimensions.dart';
import '../widgets/foods/food_card_widget.dart';
import '../widgets/pet_card_widget.dart';
import '../widgets/tools/tool_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  // @override
  // void initState() {
  //   BlocProvider.of<PetCubit>(context, listen: false).search.clear();
  //   super.initState();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt.get<PetCubit>(),
      //PetCubit(getIt(),getIt(),getIt(),getIt(),getIt(), getIt(), getIt(),getIt(), getIt(),getIt(),),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () {
        //       FocusScope.of(context).unfocus();
        //       Future.delayed(const Duration(milliseconds: 300), () {
        //         Navigator.pop(context);
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.black,
        //     ),
        //   ),
        //   backgroundColor: Colors.white,
        //   elevation: 0.0,
        //   centerTitle: true,
        //   title: Text(
        //     "Search pet",
        //     style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        //   ),
        // ),
        body: BlocBuilder<PetCubit, PetState>(builder: (context, state) {
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
                      width: Dimensions.width30 * 1.5,
                    ),
                    Text(AppLocalizations.of(context)!.search_pets,
                     // "Search pet",
                       style: TextStyles.titleTextStyle),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller,
                    style: TextStyles.textFormFieldWidgetStyle,
                    //cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.search_pets,
                      //'Search',
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
                        BlocProvider.of<PetCubit>(context)
                            .searchPet(context: context, text: value);
                      }
                      if (value.isEmpty) {
                        BlocProvider.of<PetCubit>(context).clearSearchPets();
                      }
                    },
                  ),
                ),
                if (state is LoadingSearchState)
                  Center(
                      child: CircularProgressIndicator(
                    color: AppColors().circularProgressIndicatorColor,
                  )),
                if (state is LoadedSearchState && (state.search.pets.isNotEmpty || state.search.tools.isNotEmpty || state.search.foods.isNotEmpty))
                  SizedBox(
                    height: Dimensions.screenHeight - 200,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics:const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            physics:const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.search.pets.length,
                            itemBuilder: (context, index) {
                              return PetCardWidget(
                                index: index,
                                pet: state.search.pets[index],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                const SizedBox(height: 15),
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: state.search.foods.length,
                            physics:const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return FoodCardWidget(
                                index: index,
                                food: state.search.foods[index],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: state.search.tools.length,
                            physics:const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ToolCardWidget(
                                index: index,
                                tool: state.search.tools[index],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (state is LoadedSearchState && state.search.pets.isEmpty&& state.search.tools.isEmpty&& state.search.foods.isEmpty)
                  Center(
                    child: Text(AppLocalizations.of(context)!.not_item_found,
                      //"No Search Item",
                        style: TextStyles.cardSubTitleTextStyle2),
                  ),
                // BlocBuilder<PetCubit, PetState>(
                //     //listener: (context, state) {},
                //     builder: (context, state) {
                //       if (state is LoadingSearchState) {
                //         return const Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       }
                //       if (state is LoadedSearchState ) {
                //         return state.search.isNotEmpty
                //             ? SizedBox(
                //                 height: Dimensions.screenHeight,
                //                 width: double.infinity,
                //                 child: ListView.separated(
                //                   padding:
                //                       const EdgeInsets.symmetric(vertical: 10),
                //                   itemCount: state.search.length,
                //                   physics: const NeverScrollableScrollPhysics(),
                //                   itemBuilder: (context, index) {
                //                     return ProductCardWidget(
                //                       index: index,
                //                       product: state.search[index],
                //                     );
                //                   },
                //                   separatorBuilder:
                //                       (BuildContext context, int index) =>
                //                           const SizedBox(height: 15),
                //                 ),
                //               )
                //             : Center(
                //                 child: Text(
                //                   "No Search Item",
                //                   style: TextStyles.cardSubTitleTextStyle2
                //                       .copyWith(color: Colors.black),
                //                 ),
                //               );
                //       } else {
                //         return const SizedBox();
                //       }
                //     }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
