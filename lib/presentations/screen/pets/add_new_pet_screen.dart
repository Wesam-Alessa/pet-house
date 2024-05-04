import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:pet_house/presentations/widgets/text_form_feild.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/error/show_custom_snackbar.dart';
import '../../../domain/entities/pet/pet.dart';

class AddNewPetScreen extends StatefulWidget {
  const AddNewPetScreen({Key? key}) : super(key: key);

  @override
  State<AddNewPetScreen> createState() => _AddNewPetScreenState();
}

class _AddNewPetScreenState extends State<AddNewPetScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController price = TextEditingController();

  int quantity = 0;
  int ageYears = 0;
  int ageMounth = 0;
  late List<String> genderItems ;
  //= ['male', 'female'];
  String genderValue = '';
  List<File> images = [];
  ImagePicker picker = ImagePicker();

  TextEditingController color = TextEditingController();
  TextEditingController medicalHistory = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController temperature = TextEditingController();
  TextEditingController ph = TextEditingController();
  TextEditingController specificGravity = TextEditingController();
  String dateOfBirth = DateFormat.yMd().format(DateTime.now());
  String createdDate = DateFormat.yMd().format(DateTime.now());
  String updatedDate = DateFormat.yMd().format(DateTime.now());
  late List<String> careLevels ;
  //= ['low', 'middle', 'high', 'cautiously'];
  String careLevel = '';
  List<String> tags = [];
  TextEditingController tag = TextEditingController();
  List<String> options = [];
  TextEditingController option = TextEditingController();
  List<String> diets = [];
  TextEditingController diet = TextEditingController();
  List<Vaccination> vaccinations = [];
  TextEditingController vaccinationName = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  bool sterilized = false;
  bool isFeatured = false;
  //Seller? seller;
  String categoryValue = '';
  List<String> categoryItems = [];

  Future<DateTime?> pickDateTime() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime.now(),
      );

  add(List<String> list, TextEditingController controller, String label,
      List<Vaccination> vList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors().backgroundColorCardContainer,
            title: Text(AppLocalizations.of(context)!.add_New_Label(label),
                //"Add New $label",
                style: TextStyles.titleTextStyle),
            content: label == "Vaccination"
                ? SizedBox(
                    height: Dimensions.screenHeight / 7,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller,
                          style: TextStyles.textFormFieldWidgetStyle,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .enter_your_Label_here(label),
                            //"Enter your $label here",
                            hintStyle: TextStyles.textFormFieldWidgetStyle,
                            focusColor: AppColors().borderColor,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        GestureDetector(
                          onTap: () async {
                            var pickTime = await pickDateTime();
                            if (pickTime == null) {
                              expirationDateController.text =
                                  DateTime.now().toString();
                            } else {
                              expirationDateController.text =
                                  pickTime.toString();
                            }
                            log(expirationDateController.text);
                            setState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: Dimensions.height30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.radius10 / 2),
                              ),
                              border: Border.all(
                                  width: 1.5, color: AppColors().borderColor),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                              child: Text(
                                  expirationDateController.text.isEmpty
                                      ? AppLocalizations.of(context)!
                                          .your_expiration_Date
                                      //"your expiration Date "
                                      : expirationDateController.text,
                                  style: TextStyles.cardSubTitleTextStyle2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : TextFormField(
                    controller: controller,
                    style: TextStyles.textFormFieldWidgetStyle,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .enter_your_Label_here(label),
                      //"Enter your $label here",
                      hintStyle: TextStyles.formLabelTextStyle,
                      focusColor: AppColors().borderColor,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColorLight),
                child: Text(AppLocalizations.of(context)!.cancel
                    //"CANCEL"
                    ),
                onPressed: () {
                  expirationDateController.clear();
                  controller.clear();
                  refreshUI();
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColorLight),
                child: Text(AppLocalizations.of(context)!.add
                    //"ADD"
                    ),
                onPressed: () {
                  if (label == "Vaccination") {
                    if (controller.text.isNotEmpty &&
                        expirationDateController.text.isNotEmpty) {
                      vList.add(Vaccination(
                          name: controller.text,
                          expirationDate: expirationDateController.text,
                          id: ''));
                      expirationDateController.clear();
                    } else {
                      showError(context,
                          AppLocalizations.of(context)!.error_Vaccination
                          //'The Vaccination was not added because Vaccination name or Expiration date is empty'
                          );
                    }
                  } else {
                    if (controller.text.isNotEmpty) {
                      list.add(controller.text);
                    } else {
                      showError(
                          context,
                          AppLocalizations.of(context)!
                              .error_the_label_was_not_added(label)
                          //'The $label was not added because it is empty'
                          );
                    }
                  }

                  controller.clear();
                  refreshUI();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

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
    genderItems =
        initLanguageCode == 'en' ? ['male', 'female'] : ['ذكر', 'انثى'];
    careLevels =
        initLanguageCode == 'en' ? ['low', 'middle', 'high', 'cautiously'] : ["منخفض" , "وسط" , "مرتفع" , "حذر"];    
    genderValue = genderItems[0];
    careLevel = careLevels[0];
    super.initState();
  }

  void getCategories(List<PetCategoryModel> list) {
    if (categoryItems.isEmpty) {
      for (PetCategoryModel model in list) {
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
    contact.dispose();
    location.dispose();
    type.dispose();
    images.clear();
    price.dispose();
    quantity = 0;
    ageYears = 0;
    ageMounth = 0;
    genderValue = '';
    color.dispose();
    medicalHistory.dispose();
    status.dispose();
    temperature.dispose();
    ph.dispose();
    specificGravity.dispose();
    careLevels.clear();
    careLevel = '';
    tags.clear();
    tag.dispose();
    options.clear();
    option.dispose();
    diets.clear();
    diet.dispose();
    vaccinations.clear();
    vaccinationName.dispose();
    expirationDateController.dispose();

    super.dispose();
  }

  Future<Seller> getSeller() async {
    var shared = await SharedPreferences.getInstance();
    var value = shared.getString('user') ?? '';
    Map<String, dynamic> result = jsonDecode(value);
    var seller = Seller.fromJson(result);
    return seller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PetCubit>(
      create: (context) => getIt.get<PetCubit>()..getPetCategories(context),
      child: BlocBuilder<PetCubit, PetState>(builder: (context, state) {
        if (state is LoadingState) {
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
                AppLocalizations.of(context)!.add_new_pet
                // "Add New pet"
                ,
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
        if (state is ErrorState) {
          return Center(
            child: Text(AppLocalizations.of(context)!.error_something_wrong
                //"somthing wrong !!"
                ),
          );
        }
        if (state is LoadedState) {
          getCategories(state.petCategories);
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
              title: Text(
                  AppLocalizations.of(context)!.add_new_pet
                  // "Add New pet"
                  ,
                  style: TextStyles.titleTextStyle),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (name.text.isEmpty ||
                        location.text.isEmpty ||
                        diets.isEmpty ||
                        quantity == 0 ||
                        (ageYears == 0 && ageMounth == 0)) {
                      return showError(
                          context, AppLocalizations.of(context)!.error_Fields
                          //'Please fill in the following fields: name, location, quantity, diet,age months'
                          );
                    }
                    await getSeller().then((value) {
                      BlocProvider.of<PetCubit>(context, listen: false)
                          .addNewPet(
                        context,
                        PetModel(
                          image: const [
                            PetImage(webContentLink: '', webViewLink: '')
                          ],
                          id: '',
                          name: name.text.isEmpty ? "" : name.text,
                          breed: '',
                          quantity: quantity,
                          ageInYears: ageYears,
                          ageInMonths: ageMounth,
                          gender: genderValue,
                          color: color.text,
                          vaccinations: vaccinations,
                          medicalHistory: medicalHistory.text,
                          dateOfBirth: dateOfBirth,
                          sterilized: sterilized,
                          seller: value,
                          price:
                              price.text.isEmpty ? 0 : double.parse(price.text),
                          description: description.text,
                          location: location.text,
                          status: status.text,
                          category: categoryValue,
                          viewCount: 0,
                          tags: tags,
                          options: options,
                          createdDate: createdDate,
                          updatedDate: updatedDate,
                          isFeatured: isFeatured,
                          temperature: temperature.text,
                          ph: ph.text,
                          specificGravity: specificGravity.text,
                          diet: diets,
                          careLevel: careLevel,
                          pictures: images,
                          owner: null,
                          waiting: true,
                          hidden: false,
                          reports: const [],
                        ),
                        state.pets,
                      );
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
                        title: AppLocalizations.of(context)!.name
                        //'Name'
                        ,
                        controller: name),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.description
                        //'Description'
                        ,
                        controller: description),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.type
                        //'Type'
                        ,
                        controller: type),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.address
                        //'Address'
                        ,
                        controller: location),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.contact
                        //'Contact'
                        ,
                        controller: contact),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.price
                        //'Price'
                        ,
                        controller: price,
                        number: true),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.color
                        //'Color'
                        ,
                        controller: color),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.medical_history
                        //'Medical History'
                        ,
                        controller: medicalHistory),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.status
                        //'Status'
                        ,
                        controller: status),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.temperature
                        //'Temperature'
                        ,
                        controller: temperature),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.ph
                        //'PH'
                        ,
                        controller: ph),
                    const SizedBox(height: 10),
                    TextFormFieldWidget(
                        title: AppLocalizations.of(context)!.specific_Gravity
                        //'Specific Gravity'
                        ,
                        controller: specificGravity),
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
                              //'Category',
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
                    // Gender
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.g_mobiledata,
                              color: AppColors().iconColor,
                              size: Dimensions.iconSize24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context)!.gender,
                              //'Gender',
                              style: TextStyles.formLabelTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                            value: genderValue,
                            style: TextStyles.formLabelTextStyle,
                            dropdownColor: AppColors().backgroundColorScaffold,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors().iconColor,
                            ),
                            items: genderItems.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items,
                                    style: TextStyles.formLabelTextStyle),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                genderValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // CARE LEVEL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              color: AppColors().iconColor,
                              size: Dimensions.iconSize24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context)!.care_level,
                              //'Care Level',
                              style: TextStyles.formLabelTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                            value: careLevel,
                            style: TextStyles.formLabelTextStyle,
                            dropdownColor: AppColors().backgroundColorScaffold,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors().iconColor,
                            ),
                            items: careLevels.map((String items) {
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
                                careLevel = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Tags
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10 / 2),
                      ),
                      leading:
                          Icon(Icons.tag_sharp, color: AppColors().iconColor),
                      title: Text(
                        "${AppLocalizations.of(context)!.tags} ${tags.isNotEmpty ? "${tags[0]} ...." : ""}",
                        style: TextStyles.formLabelTextStyle,
                      ),
                      trailing: Icon(Icons.add_circle_outline_outlined,
                          color: AppColors().iconColor),
                      onTap: () => add(tags, tag, 'Tag', []),
                    ),
                    const SizedBox(height: 10),
                    // Options
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10 / 2),
                      ),
                      leading: Icon(Icons.apps_outage_rounded,
                          color: AppColors().iconColor),
                      title: Text(
                          "${AppLocalizations.of(context)!.options} ${options.isNotEmpty ? "${options[0]} ...." : ""}",
                          style: TextStyles.formLabelTextStyle),
                      trailing: Icon(Icons.add_circle_outline_outlined,
                          color: AppColors().iconColor),
                      onTap: () => add(options, option, 'Option', []),
                    ),
                    const SizedBox(height: 10),
                    //Diets
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10 / 2),
                      ),
                      leading: Icon(Icons.fastfood_outlined,
                          color: AppColors().iconColor),
                      title: Text(
                          "${AppLocalizations.of(context)!.diets} ${diets.isNotEmpty ? "${diets[0]} ...." : ""}",
                          style: TextStyles.formLabelTextStyle),
                      trailing: Icon(Icons.add_circle_outline_outlined,
                          color: AppColors().iconColor),
                      onTap: () => add(diets, diet, 'Diet', []),
                    ),
                    const SizedBox(height: 10),
                    // Vaccinations
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10 / 2),
                      ),
                      leading: Icon(Icons.vaccines_outlined,
                          color: AppColors().iconColor),
                      title: Text(
                          "${vaccinations.length} ${AppLocalizations.of(context)!.vaccinations}",
                          style: TextStyles.formLabelTextStyle),
                      trailing: Icon(Icons.add_circle_outline_outlined,
                          color: AppColors().iconColor),
                      onTap: () =>
                          add([], vaccinationName, 'Vaccination', vaccinations),
                    ),
                    const SizedBox(height: 10),
                    // Date of Birth
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.5, color: AppColors().borderColor),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10 / 2),
                      ),
                      leading: Icon(Icons.date_range_outlined,
                          color: AppColors().iconColor),
                      title: Text(
                        "${AppLocalizations.of(context)!.date_of_Birth} $dateOfBirth",
                        style: TextStyles.formLabelTextStyle,
                      ),
                      trailing: Icon(Icons.add_circle_outline_outlined,
                          color: AppColors().iconColor),
                      onTap: () async {
                        var result = await pickDateTime();
                        dateOfBirth = result == null
                            ? DateFormat.yMd().format(DateTime.now())
                            : DateFormat.yMd().format(result);
                        refreshUI();
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.age_years,
                                //"Age years",
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
                                          if (ageYears > 0) {
                                            setState(() {
                                              ageYears--;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.remove,
                                            color: AppColors().iconColor)),
                                    Text("$ageYears",
                                        style:
                                        TextStyles.formLabelTextStyle),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            ageYears++;
                                          });
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors().iconColor,
                                        )),
                                  ]),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.age_months,
                                //"Age months",
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
                                          if (ageMounth > 0) {
                                            setState(() {
                                              ageMounth--;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.remove,
                                            color: AppColors().iconColor)),
                                    Text("$ageMounth",
                                        style:
                                        TextStyles.formLabelTextStyle),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            ageMounth++;
                                          });
                                        },
                                        child: Icon(Icons.add,
                                            color: AppColors().iconColor)),
                                  ]),
                            ),
                          ],
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
                                      style:TextStyles.formLabelTextStyle),
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
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.sterilized,
                                //"Sterilized",
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
                                  Text(AppLocalizations.of(context)!.no,
                                      //"No",
                                      style: TextStyles.formLabelTextStyle),
                                  Switch(
                                    value: sterilized,
                                    onChanged: (value) {
                                      setState(() {
                                        sterilized = value;
                                      });
                                      log(sterilized.toString());
                                    },
                                    activeTrackColor:
                                        AppColors().primaryColorLight,
                                    activeColor: Colors.white38,
                                  ),
                                  Text(AppLocalizations.of(context)!.yes,
                                      //"Yes",
                                      style: TextStyles.formLabelTextStyle),
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
