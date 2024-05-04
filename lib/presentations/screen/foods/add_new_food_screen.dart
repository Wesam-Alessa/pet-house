import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/data/models/tools/pet_tool_category.dart';
import 'package:pet_house/domain/entities/tools/pet_tools.dart';
import 'package:pet_house/presentations/controllers/tools/tools_cubit.dart';
import 'package:pet_house/presentations/widgets/text_form_feild.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/error/show_custom_snackbar.dart';
import '../../../data/models/foods/pet_food_category.dart';
import '../../../data/models/foods/pet_foods_model.dart';
import '../../../data/models/tools/pet_tool_model.dart';
import '../../../domain/entities/foods/pet_foods.dart';
import '../../controllers/pet_foods/pet_foods_cubit.dart';

class AddNewFoodScreen extends StatefulWidget {
  const AddNewFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddNewFoodScreen> createState() => _AddNewFoodScreenState();
}

class _AddNewFoodScreenState extends State<AddNewFoodScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController price = TextEditingController();

  int quantity = 0;
  List<File> images = [];
  ImagePicker picker = ImagePicker();

  TextEditingController color = TextEditingController();
  TextEditingController status = TextEditingController();
  String createdDate = DateFormat.yMd().format(DateTime.now());
  String updatedDate = DateFormat.yMd().format(DateTime.now());
  bool isFeatured = false;
  String categoryValue = '';
  List<String> categoryItems = [];

  Future<DateTime?> pickDateTime() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime.now(),
      );

  refreshUI() => setState(() {});

  void pickImages() async {
    images.clear();
    List<XFile> pImage = [];
    pImage = await picker.pickMultiImage();
    for (var image in pImage) {
      images.add(File(image.path));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void getCategories(List<PetFoodsCategoryModel> list) {
    if (categoryItems.isEmpty) {
      for (PetFoodsCategoryModel model in list) {
        categoryItems.add(model.label);
      }
      categoryValue = list[0].label;
    }
  }

  @override
  void dispose() {
    categoryItems.clear();
    categoryValue = '';
    name.dispose();
    description.dispose();

    location.dispose();

    images.clear();
    price.dispose();
    quantity = 0;

    color.dispose();

    status.dispose();

    super.dispose();
  }

  Future<FoodsSeller> getSeller() async {
    var shared = await SharedPreferences.getInstance();
    var value = shared.getString('user') ?? '';
    Map<String, dynamic> result = jsonDecode(value);
    var seller = FoodsSeller.fromJson(result);
    return seller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PetFoodsCubit>(
      create: (context) => getIt.get<PetFoodsCubit>()..getPetFoodsCategories(context),
      child: BlocBuilder<PetFoodsCubit, PetFoodsState>(builder: (context, state) {
        if (state is LoadingPetFoodsCategoriesState || state is LoadingFoodsState) {
          return Scaffold(
            backgroundColor: AppColors().backgroundColorScaffold,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors().iconColor,
                  //Colors.black,
                ),
              ),
              backgroundColor: AppColors().backgroundColorScaffold,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.add_new_food,
                style: TextStyles.titleTextStyle,
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors().circularProgressIndicatorColor,
              ),
            ),
          );
        }
        if (state is ErrorLoadingPetFoodsCategoriesState) {
          return Scaffold(
              backgroundColor: AppColors().backgroundColorScaffold,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors().iconColor,
                    //Colors.black,
                  ),
                ),
                backgroundColor: AppColors().backgroundColorScaffold,
                elevation: 0.0,
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.add_new_food,
                  style: TextStyles.titleTextStyle,
                ),
              ),
              body: Center(
                child: Text(AppLocalizations.of(context)!.error_something_wrong
                    //"somthing wrong !!"
                    ),
              ));
        }
        if (state is LoadedPetFoodsCategoriesState ) {
          getCategories(state.categories);
          return Scaffold(
            backgroundColor: AppColors().backgroundColorScaffold,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, color: AppColors().iconColor),
              ),
              backgroundColor: AppColors().backgroundColorScaffold,
              elevation: 0.0,
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.add_new_food,
                  style: TextStyles.titleTextStyle),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (name.text.isEmpty ||
                        location.text.isEmpty ||
                        quantity == 0) {
                      return showError(
                          context, AppLocalizations.of(context)!.error_Fields
                          //'Please fill in the following fields: name, location, quantity, diet,age months'
                          );
                    }
                    await getSeller().then((value) {
                      BlocProvider.of<PetFoodsCubit>(context, listen: false)
                          .addNewFood(
                              context,
                              PetFoodsModel(
                                image: const [
                                  PetFoodsImage(
                                      webContentLink: '', webViewLink: '')
                                ],
                                id: '',
                                name: name.text.isEmpty ? "" : name.text,
                                quantity: quantity,
                                color: color.text,
                                seller: value,
                                price: price.text.isEmpty
                                    ? 0
                                    : double.parse(price.text),
                                description: description.text,
                                location: location.text,
                                status: status.text,
                                category: categoryValue,
                                viewCount: 0,
                                createdDate: createdDate,
                                updatedDate: updatedDate,
                                isFeatured: isFeatured,
                                pictures: images,
                                waiting: true,
                                hidden: false,
                                reports: const [],
                              ),
                              //state.pets,
                              []);
                    });
                  },
                  icon: Icon(
                    Icons.file_upload_outlined,
                    color: AppColors().iconColor,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: Dimensions.screenHeight / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radius10 / 2),
                        ),
                        border: Border.all(
                            width: 1, color: AppColors().borderColor),
                      ),
                      child: images.isEmpty
                          ? Center(
                              child: IconButton(
                                  onPressed: pickImages,
                                  icon: Icon(
                                    Icons.add,
                                    size: Dimensions.iconSize24,
                                    color: AppColors().iconColor,
                                  )))
                          : ListView.builder(
                              itemCount: images.length,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              itemBuilder: ((context, index) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          images[index],
                                          fit: BoxFit.cover,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              images.remove(images[index]);
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: Dimensions.radius25 / 2,
                                            backgroundColor: AppColors()
                                                .backgroundColorCircleAvatar,
                                            child: Center(
                                                child: Icon(
                                              Icons.close,
                                              size: Dimensions.iconSize18,
                                              color: AppColors().iconColor,
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))),
                    ),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.name,
                        controller: name),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.description,
                        controller: description),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.address,
                        controller: location),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.price,
                        controller: price,
                        number: true),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.color,
                        controller: color),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.status,
                        controller: status),
                    const SizedBox(height: 10),
                    // Category
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              color: AppColors().iconColor,
                              size: Dimensions.iconSize24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context)!.category,
                              style: TextStyles.formLabelTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (categoryItems.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.radius10 / 2),
                              ),
                              border: Border.all(
                                  width: 1.5, color: AppColors().borderColor),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: DropdownButton(
                              underline: Container(),
                              isExpanded: true,
                              value: categoryValue,
                              style: TextStyles.formLabelTextStyle,
                              dropdownColor:
                                  AppColors().backgroundColorScaffold,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors().iconColor),
                              items: categoryItems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyles.formLabelTextStyle,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  categoryValue = newValue!;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.quantity,
                                //"Quantity",
                                style: TextStyles.formLabelTextStyle
                                //.copyWith(color: Colors.grey.shade700),
                                ),
                            const SizedBox(height: 5),
                            Container(
                              height: Dimensions.height45,
                              width: Dimensions.screenWidth / 3,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius10),
                                border: Border.all(
                                    color: AppColors().borderColor, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        if (quantity > 0) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: AppColors().iconColor,
                                      )),
                                  Text("$quantity",
                                      style: TextStyles.formLabelTextStyle),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors().iconColor,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is LoadedFoodsState ) {
          return Scaffold(
            backgroundColor: AppColors().backgroundColorScaffold,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, color: AppColors().iconColor),
              ),
              backgroundColor: AppColors().backgroundColorScaffold,
              elevation: 0.0,
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.add_new_food,
                  style: TextStyles.titleTextStyle),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (name.text.isEmpty ||
                        location.text.isEmpty ||
                        quantity == 0) {
                      return showError(
                          context, AppLocalizations.of(context)!.error_Fields
                        //'Please fill in the following fields: name, location, quantity, diet,age months'
                      );
                    }
                    await getSeller().then((value) {
                      BlocProvider.of<PetFoodsCubit>(context, listen: false)
                          .addNewFood(
                          context,
                          PetFoodsModel(
                            image: const [
                              PetFoodsImage(
                                  webContentLink: '', webViewLink: '')
                            ],
                            id: '',
                            name: name.text.isEmpty ? "" : name.text,
                            quantity: quantity,
                            color: color.text,
                            seller: value,
                            price: price.text.isEmpty
                                ? 0
                                : double.parse(price.text),
                            description: description.text,
                            location: location.text,
                            status: status.text,
                            category: categoryValue,
                            viewCount: 0,
                            createdDate: createdDate,
                            updatedDate: updatedDate,
                            isFeatured: isFeatured,
                            pictures: images,
                            waiting: true,
                            hidden: false,
                            reports: const [],
                          ),
                          //state.pets,
                          []);
                    });
                  },
                  icon: Icon(
                    Icons.file_upload_outlined,
                    color: AppColors().iconColor,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: Dimensions.screenHeight / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radius10 / 2),
                        ),
                        border: Border.all(
                            width: 1, color: AppColors().borderColor),
                      ),
                      child: images.isEmpty
                          ? Center(
                          child: IconButton(
                              onPressed: pickImages,
                              icon: Icon(
                                Icons.add,
                                size: Dimensions.iconSize24,
                                color: AppColors().iconColor,
                              )))
                          : ListView.builder(
                          itemCount: images.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          itemBuilder: ((context, index) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  images[index],
                                  fit: BoxFit.cover,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      images.remove(images[index]);
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: Dimensions.radius25 / 2,
                                    backgroundColor: AppColors()
                                        .backgroundColorCircleAvatar,
                                    child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: Dimensions.iconSize18,
                                          color: AppColors().iconColor,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ))),
                    ),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.name,
                        controller: name),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.description,
                        controller: description),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.address,
                        controller: location),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.price,
                        controller: price,
                        number: true),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.color,
                        controller: color),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.status,
                        controller: status),
                    const SizedBox(height: 10),
                    // Category
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              color: AppColors().iconColor,
                              size: Dimensions.iconSize24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context)!.category,
                              style: TextStyles.formLabelTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (categoryItems.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.radius10 / 2),
                              ),
                              border: Border.all(
                                  width: 1.5, color: AppColors().borderColor),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: DropdownButton(
                              underline: Container(),
                              isExpanded: true,
                              value: categoryValue,
                              style: TextStyles.formLabelTextStyle,
                              dropdownColor:
                              AppColors().backgroundColorScaffold,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors().iconColor),
                              items: categoryItems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyles.formLabelTextStyle,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  categoryValue = newValue!;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.quantity,
                                //"Quantity",
                                style: TextStyles.formLabelTextStyle
                              //.copyWith(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: Dimensions.height45,
                              width: Dimensions.screenWidth / 3,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(Dimensions.radius10),
                                border: Border.all(
                                    color: AppColors().borderColor, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        if (quantity > 0) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: AppColors().iconColor,
                                      )),
                                  Text("$quantity",
                                      style: TextStyles.formLabelTextStyle),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors().iconColor,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(
          child: Text(AppLocalizations.of(context)!.error_something_wrong,
              //"sonthing wrong !!",
              style: TextStyles.cardSubTitleTextStyle2),
        );
      }),
    );
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }
}
