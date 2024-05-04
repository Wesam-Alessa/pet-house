import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/main.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/presentations/controllers/tools/tools_cubit.dart';
import 'package:pet_house/presentations/screen/pets/category_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pet_house/presentations/screen/tools/tools_category_screen.dart';

import '../../core/services/service_locator.dart';
import '../controllers/pet_foods/pet_foods_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              getIt.get<PetCubit>()..getCategories(context),
        ),
        BlocProvider(
            create: (BuildContext context) =>
                getIt.get<ToolsCubit>()..getToolsCategories(context)),
        BlocProvider(
            create: (BuildContext context) =>
                getIt.get<PetFoodsCubit>()..getPetFoodsCategories(context)),
      ],
      child: AnimatedContainer(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor)
          ..rotateY(isDrawerOpen ? -0.5 : 0),
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: AppColors().backgroundColorScaffold,
            //Colors.grey[200],
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Theme.of(context).primaryColor,
          backgroundColor: AppColors().backgroundColorScaffold,
          strokeWidth: 2.0,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            await Future<void>.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ));
            });
          },
          child: Scaffold(
            backgroundColor: AppColors().backgroundColorScaffold,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isDrawerOpen
                              ? IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors().iconColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: AppColors().iconColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      xOffset =
                                          initLanguageCode == 'en' ? 230 : -30;
                                      yOffset = 150;
                                      scaleFactor = 0.6;
                                      isDrawerOpen = true;
                                    });
                                  }),
                          Text(AppLocalizations.of(context)!.petHouse,
                              //'Pet House',
                              style: TextStyles.titleTextStyle),
                          CircleAvatar(
                            radius: Dimensions.radius20,
                            backgroundImage:
                                const AssetImage("assets/pet_logo.png"),
                          )
                        ],
                      ),
                    ),
                    // Search
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, SEARCH_SCREEN),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            boxShadow: AppColors().shadowList,
                            color: AppColors().backgroundColorCardContainer,
                            //Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppColors().iconColor,
                            ),
                            SizedBox(width: Dimensions.screenWidth * 0.18),
                            Text(
                                AppLocalizations.of(context)!
                                    .search_pet_to_adopt_or_buy,
                                //'Search pet to adopt or buy',
                                style: TextStyles.bodyTextStyle),
                          ],
                        ),
                      ),
                    ),
                    // Pet Categories
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.height10),
                      child: Text(AppLocalizations.of(context)!.pets,
                          style: TextStyles.subscriptionTitleTextStyle),
                    ),
                    BlocBuilder<PetCubit, PetState>(
                      builder: (context, state) {
                        if (state is LoadingCategoriesState) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: AppColors().circularProgressIndicatorColor,
                          ));
                        }
                        if (state is LoadedCategoriesState) {
                          return state.categories.isNotEmpty
                              ? SizedBox(
                                  height: Dimensions.screenHeight * 0.27,
                                  width: double.infinity,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(10),
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CategoryScreen(
                                                        catName: state
                                                            .categories[index]
                                                            .label,
                                                      )));
                                        },
                                        child: Container(
                                          height: 110,
                                          decoration: BoxDecoration(
                                              color: AppColors()
                                                  .backgroundColorCardContainer,
                                              boxShadow: AppColors().shadowList,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          state
                                                              .categories[index]
                                                              .imageUrl),fit: BoxFit.fill)),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              state.categories[index].label,
                                              style: TextStyles
                                                  .categoryLabelTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox();
                        } else {
                          return Center(
                            child: Text(AppLocalizations.of(context)!.no_Items,
                                //"No Items",
                                style: TextStyles.cardSubTitleTextStyle2),
                          );
                        }
                      },
                    ),
                    // Tools Categories
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.height10),
                      child: Text(
                          AppLocalizations.of(context)!.tools,
                          style: TextStyles.subscriptionTitleTextStyle),
                    ),
                    BlocBuilder<ToolsCubit, ToolsState>(
                      builder: (context, state) {
                        if (state is LoadingToolsCategoriesState) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: AppColors().circularProgressIndicatorColor,
                          ));
                        }
                        if (state is LoadedToolsCategoriesState) {
                          return state.categories.isNotEmpty
                              ? SizedBox(
                                  height: Dimensions.screenHeight * 0.27,
                                  width: double.infinity,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(10),
                                    itemCount: state.categories.isEmpty
                                        ? 0
                                        : state.categories.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ToolsCategoryScreen(
                                                        catName: state
                                                            .categories[index]
                                                            .label,
                                                      )));
                                        },
                                        child: Container(
                                          height: 110,
                                          decoration: BoxDecoration(
                                              color: AppColors()
                                                  .backgroundColorCardContainer,
                                              boxShadow: AppColors().shadowList,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          state
                                                              .categories[index]
                                                              .imageUrl),fit: BoxFit.fill)),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              state.categories[index].label,
                                              textAlign: TextAlign.center,
                                              style: TextStyles
                                                  .categoryLabelTextStyle,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                              : const SizedBox();
                        } else {
                          return Center(
                            child: Text(AppLocalizations.of(context)!.no_Items,
                                //"No Items",
                                style: TextStyles.cardSubTitleTextStyle2),
                          );
                        }
                      },
                    ),
                    // Pet Foods Categories
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.height10),
                      child: Text(
                          AppLocalizations.of(context)!.foods,
                          style: TextStyles.subscriptionTitleTextStyle),
                    ),
                    BlocBuilder<PetFoodsCubit, PetFoodsState>(
                      builder: (context, state) {
                        if (state is LoadingPetFoodsCategoriesState) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: AppColors().circularProgressIndicatorColor,
                          ));
                        }
                        if (state is LoadedPetFoodsCategoriesState) {
                          return state.categories.isNotEmpty
                              ? SizedBox(
                                  height: Dimensions.screenHeight * 0.27,
                                  width: double.infinity,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(10),
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ToolsCategoryScreen(
                                                        catName: state
                                                            .categories[index]
                                                            .label,
                                                      )));
                                        },
                                        child: Container(
                                          height: 110,
                                          decoration: BoxDecoration(
                                              color: AppColors()
                                                  .backgroundColorCardContainer,
                                              boxShadow: AppColors().shadowList,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(

                                                  image:
                                                      CachedNetworkImageProvider(
                                                          state
                                                              .categories[index]
                                                              .imageUrl),fit: BoxFit.fill)),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              state.categories[index].label,
                                              textAlign: TextAlign.center,
                                              style: TextStyles
                                                  .categoryLabelTextStyle,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox();
                        } else {
                          return Center(
                            child: Text(AppLocalizations.of(context)!.no_Items,
                                //"No Items",
                                style: TextStyles.cardSubTitleTextStyle2),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
