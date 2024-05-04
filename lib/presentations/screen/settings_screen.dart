import 'dart:developer';
import 'dart:io';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/data/models/intellectual_property_rights_model.dart';
import 'package:pet_house/data/models/pet_category_model.dart';
import 'package:pet_house/main.dart';
import 'package:pet_house/presentations/controllers/App/app_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_house/presentations/controllers/tools/tools_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/error/show_custom_snackbar.dart';
import '../../data/models/foods/pet_food_category.dart';
import '../../data/models/tools/pet_tool_category.dart';
import '../controllers/pet/pet_cubit.dart';
import '../controllers/pet_foods/pet_foods_cubit.dart';
import '../controllers/user/user_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? image;
  ImagePicker picker = ImagePicker();
  TextEditingController label = TextEditingController();
  bool isHidden = false;

  @override
  void initState() {
    globalAppCubit.getIntellectualPropertyRights(context);
    super.initState();
  }

  @override
  void dispose() {
    label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColorScaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors().backgroundColorScaffold,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors().iconColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.settings,
            style: TextStyles.titleTextStyle),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //add Pet category
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.category, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.add_new_pet_category,
                    //"Add New Category",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.add_circle_outline_outlined,
                      color: AppColors().iconColor),
                  onTap: () => add(label, context, true, false, false),
                ),
              //update Pet category
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.category, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.update_pet_category,
                    // "Update Category",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing:
                      Icon(Icons.edit_outlined, color: AppColors().iconColor),
                  onTap: () =>
                      updateCategory(label, context, true, false, false),
                ),
              if (isAdmin) const SizedBox(height: 10),
              //add Tools category
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.category, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.add_new_tools_category,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.add_circle_outline_outlined,
                      color: AppColors().iconColor),
                  onTap: () => add(label, context, false, true, false),
                ),
              //update Tools category
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.category, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.update_tools_category,
                    // "Update Category",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing:
                      Icon(Icons.edit_outlined, color: AppColors().iconColor),
                  onTap: () =>
                      updateCategory(label, context, false, true, false),
                ),
              if (isAdmin) const SizedBox(height: 10),
              //add Pet Foods category
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.category, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.add_new_foods_category,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.add_circle_outline_outlined,
                      color: AppColors().iconColor),
                  onTap: () => add(label, context, false, false, true),
                ),
              //update Pet Foods category
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.category, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.update_foods_category,
                    // "Update Category",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing:
                      Icon(Icons.edit_outlined, color: AppColors().iconColor),
                  onTap: () =>
                      updateCategory(label, context, false, false, true),
                ),
              //publishing waiting pets
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.public, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.waiting_pets,
                    // "Waiting pets",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.publish_outlined,
                      color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, WAITING_PETS_SCREEN),
                ),
              //publishing waiting Tools
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                    BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                    BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.pan_tool_outlined, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.waiting_tools,
                    // "Waiting pets",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.publish_outlined,
                      color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, WAITING_TOOLS_SCREEN),
                ),
              //publishing waiting Food
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                    BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                    BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.food_bank_outlined, color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.waiting_foods,
                    // "Waiting pets",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.publish_outlined,
                      color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, WAITING_FOODS_SCREEN),
                ),
              // Reported Items SCreen
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.ad_units_outlined,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.reported_items,
                    // "Reported Items",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.report_problem_outlined,
                      color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, REPORTED_ITEMS_SCREEN),
                ),
              // Item Deletion Reports
              if (isAdmin) const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.report_gmailerrorred_sharp,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.item_Deletion_Reports,
                    //"Item Deletion Reports",
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.report_problem_outlined,
                      color: AppColors().iconColor),
                  onTap: () => Navigator.pushNamed(
                      context, ITEM_DELETION_REPORTS_SCREEN),
                ),
              //Intellectual property rights
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.5, color: AppColors().borderColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius10 / 2),
                ),
                leading: Icon(Icons.copyright, color: AppColors().iconColor),
                title: Text(
                  AppLocalizations.of(context)!.intellectual_property_rights,
                  //"Intellectual property rights",
                  style: TextStyles.textFormFieldWidgetStyle,
                ),
                trailing:
                    Icon(Icons.open_in_new_sharp, color: AppColors().iconColor),
                onTap: () {
                  log("globalIntellectualPropertyRights => ");
                  log(globalIntellectualPropertyRights.toString());
                  showText(
                      globalIntellectualPropertyRights == null
                          ? ""
                          : globalIntellectualPropertyRights!.text,
                      context);
                },
              ),
              //Languages
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.5, color: AppColors().borderColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius10 / 2),
                ),
                leading: Icon(Icons.language, color: AppColors().iconColor),
                title: Text(
                  AppLocalizations.of(context)!.language,
                  style: TextStyles.textFormFieldWidgetStyle,
                ),
                trailing: Icon(Icons.edit_attributes_outlined,
                    color: AppColors().iconColor),
                onTap: () {
                  editLanguage(context);
                },
              ),
              //"Light Theme && Dark Theme"
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.5, color: AppColors().borderColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius10 / 2),
                ),
                leading: isDarkTheme
                    ? Icon(Icons.dark_mode, color: AppColors().iconColor)
                    : Icon(Icons.dark_mode_outlined,
                        color: AppColors().iconColor),
                title: Text(
                  isDarkTheme
                      ? AppLocalizations.of(context)!.light_Theme
                      : AppLocalizations.of(context)!.dark_Theme,
                  style: TextStyles.textFormFieldWidgetStyle,
                ),
                trailing: Switch(
                  value: isDarkTheme,
                  onChanged: (value) async {
                    isDarkTheme = value;
                    await getIt
                        .get<SharedPreferences>()
                        .setBool('isDarkTheme', isDarkTheme)
                        .then((value) {
                      bool x = getIt
                              .get<SharedPreferences>()
                              .getBool('isDarkTheme') ??
                          false;
                      log("dark theme $x");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const MyApp()));
                    });
                  },
                  activeTrackColor: AppColors().primaryColorLight,
                  activeColor: Colors.white38,
                ),
              ),
              if (isAdmin)
              //"Feedback Reports List"
                const SizedBox(height: 10),
              if (isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.feedback_outlined,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.feedback_reports_list,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.list_alt_outlined,
                      color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, FEEDBACK_REPORTS_SCREEN),
                ),
              //"Add Feedback Report"
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.5, color: AppColors().borderColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius10 / 2),
                ),
                leading:
                    Icon(Icons.feedback_outlined, color: AppColors().iconColor),
                title: Text(
                  AppLocalizations.of(context)!.send_feedback_report,
                  style: TextStyles.textFormFieldWidgetStyle,
                ),
                trailing: Icon(Icons.add_comment_rounded,
                    color: AppColors().iconColor),
                onTap: () => addFeedbackReport(context),
              ),
              if (isManager)
              //"Feedback Reports List"
                const SizedBox(height: 10),
              if (isManager)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.account_circle_outlined,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!
                        .change_the_status_of_officials,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.edit, color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, STATUS_OF_OFFICIALS_SCREEN),
                ),
              if (isManager || isAdmin)
              // closed accounts List
                const SizedBox(height: 10),
              if (isManager || isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.no_accounts_outlined,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.closed_accounts,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.edit, color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, CLOSED_ACCOUNTS_SCREEN),
                ),
              if (isManager || isAdmin)
              // objection report List
                const SizedBox(height: 10),
              if (isManager || isAdmin)
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.repeat_one_sharp,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.objection_reports,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.edit, color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, OBJECTION_REPORTS_SCREEN),
                ),
            ],
          ),
        ),
      ),
    );
  }

  addFeedbackReport(mcontext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, localSetState) {
            return AlertDialog(
              scrollable: true,
              title: Text(AppLocalizations.of(mcontext)!.send_feedback_report),
              content: TextFormField(
                controller: label,
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(mcontext)!
                        .enter_new_feedback_report),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    label.clear();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.send),
                  onPressed: () {
                    globalUserCubit.sendfeedbackReport(mcontext, label.text);
                    label.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  editLanguage(mcontext) {
    String lan = initLanguageCode;
    showDialog(
      context: mcontext,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: lan == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(mcontext)!.edit_language),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: const Text("Arabic"),
                    value: "ar",
                    groupValue: lan,
                    onChanged: (value) {
                      lan = value.toString();
                      log(lan.toString());
                      setState(() {});
                    },
                  ),
                  RadioListTile(
                    title: const Text("English"),
                    value: "en",
                    groupValue: lan,
                    onChanged: (value) {
                      lan = value.toString();
                      log(lan.toString());
                      setState(() {});
                    },
                  )
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(
                    AppLocalizations.of(mcontext)!.close,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.edit),
                  onPressed: () {
                    initLanguageCode = lan;
                    getIt
                        .get<SharedPreferences>()
                        .setString("initLanguageCode", lan)
                        .then((value) {
                      // Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const MyApp()));
                    });
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  showText(String text, mcontext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                  AppLocalizations.of(mcontext)!.intellectual_property_rights),
              content: RichText(
                text: TextSpan(
                    text: text, style: const TextStyle(color: Colors.black)),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(
                    AppLocalizations.of(mcontext)!.close,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (isAdmin)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColorLight),
                    child: Text(AppLocalizations.of(mcontext)!.edit),
                    onPressed: () {
                      label.text = text;
                      editText(mcontext);
                    },
                  ),
              ],
            );
          }),
        );
      },
    );
  }

  editText(mcontext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, localSetState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                  AppLocalizations.of(mcontext)!.intellectual_property_rights),
              content: TextFormField(
                controller: label,
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(mcontext)!
                        .enter_new_intellectual_property_rights),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    label.clear();
                    Navigator.of(context).pop();
                  },
                ),
                if (isAdmin)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColorLight),
                    child: Text(AppLocalizations.of(mcontext)!.update),
                    onPressed: () {
                      globalAppCubit.updateIntellectualPropertyRights(
                          context,
                          IntellectualPropertyRightsModel(
                              id: globalIntellectualPropertyRights!.id,
                              text: label.text));
                      label.clear();
                      setState(() {
                        Navigator.of(context).pop();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
          }),
        );
      },
    );
  }

  updateCategory(TextEditingController controller, mcontext, bool isPet,
      bool isTools, bool isFoods) {
    int counter = 0;
    if (isPet) counter = globalCategories.length;
    if (isTools) counter = globalToolsCategories.length;
    if (isFoods) counter = globalPetFoodsCategories.length;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: isPet
                  ? Text(AppLocalizations.of(mcontext)!.add_new_pet_category)
                  : isTools
                      ? Text(
                          AppLocalizations.of(mcontext)!.add_new_tools_category)
                      : isFoods
                          ? Text(AppLocalizations.of(mcontext)!
                              .add_new_foods_category)
                          : const Text(''),
              content: Container(
                color: Colors.white,
                width: double.maxFinite,
                child: ListView.separated(
                  itemCount: counter,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 120,
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        boxShadow: AppColors().shadowList,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: isPet
                                      ? CachedNetworkImageProvider(
                                          globalCategories[index].imageUrl)
                                      : isTools
                                          ? CachedNetworkImageProvider(
                                              globalToolsCategories[index]
                                                  .imageUrl)
                                          : CachedNetworkImageProvider(
                                              globalPetFoodsCategories[index]
                                                  .imageUrl),
                                )),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Dimensions.screenWidth / 3,
                                child: Text(
                                  isPet
                                      ? globalCategories[index].label
                                      : isTools
                                          ? globalToolsCategories[index].label
                                          : isFoods
                                              ? globalPetFoodsCategories[index]
                                                  .label
                                              : '',
                                  style: TextStyles.categoryLabelTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${AppLocalizations.of(mcontext)!.hidden} : ",
                                    style: TextStyles.labelTextStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                  isPet
                                      ? (globalCategories[index].hidden
                                          ? Icon(Icons.check_circle_rounded,
                                              color: AppColors().primaryGreen)
                                          : Icon(Icons.close,
                                              color: AppColors().primaryGreen))
                                      : isTools
                                          ? (globalToolsCategories[index].hidden
                                              ? Icon(Icons.check_circle_rounded,
                                                  color:
                                                      AppColors().primaryGreen)
                                              : Icon(Icons.close,
                                                  color:
                                                      AppColors().primaryGreen))
                                          : isFoods
                                              ? (globalPetFoodsCategories[index]
                                                      .hidden
                                                  ? Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      color: AppColors()
                                                          .primaryGreen)
                                                  : Icon(Icons.close,
                                                      color: AppColors()
                                                          .primaryGreen))
                                              : const Icon(null)
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    maximumSize: const Size(120, 40),
                                    backgroundColor:
                                        AppColors().primaryColorLight),
                                onPressed: () {
                                  isHidden = isPet
                                      ? globalCategories[index].hidden
                                      : isTools
                                          ? globalToolsCategories[index].hidden
                                          : isFoods
                                              ? globalPetFoodsCategories[index]
                                                  .hidden
                                              : false;
                                  if (isPet) {
                                    editCategory(label, globalCategories[index],
                                        mcontext);
                                  }
                                  if (isTools) {
                                    editToolsCategory(label,
                                        globalToolsCategories[index], mcontext);
                                  }
                                  if (isFoods) {
                                    editPetFoodsCategory(
                                        label,
                                        globalPetFoodsCategories[index],
                                        mcontext);
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(mcontext)!.edit,
                                  //'EDIT',
                                  style: TextStyles.labelTextStyle
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 10,
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  editPetFoodsCategory(
    TextEditingController controller,
    PetFoodsCategoryModel category,
    mcontext,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(mcontext)!.edit_category),
              content: SizedBox(
                height: Dimensions.screenHeight / 3.5,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(mcontext)!
                            .enter_new_category_label,
                        //"Enter New Category label here",
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    GestureDetector(
                        onTap: () {
                          pickImages().then((value) => setState(() {}));
                        },
                        child: image != null
                            ? Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height30 * 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.radius10 / 2),
                                    ),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    image: DecorationImage(
                                        image: FileImage(image!))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              )
                            : Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height30 * 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.radius10 / 2),
                                    ),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            category.imageUrl))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${AppLocalizations.of(mcontext)!.hidden} : ",
                            style: TextStyles.labelTextStyle),
                        Icon(Icons.close, color: AppColors().primaryGreen),
                        Switch(
                            value: isHidden,
                            onChanged: (val) {
                              isHidden = val;
                              setState(() {});
                            }),
                        Icon(Icons.check_circle_rounded,
                            color: AppColors().primaryGreen),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.cancel),
                  onPressed: () {
                    controller.clear();
                    image = null;
                    refreshUI();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColorLight),
                    child: Text(AppLocalizations.of(mcontext)!.update),
                    onPressed: () {
                      globalPetFoodsCubit.updatePetFoodsCategory(
                        context,
                        PetFoodsCategoryModel(
                            label: label.text.isEmpty
                                ? category.label
                                : label.text,
                            imageUrl: image == null ? category.imageUrl : '',
                            id: category.id,
                            hidden: isHidden,
                            picture: image),
                      );
                      controller.clear();
                      image = null;
                      Navigator.of(context).pop();
                    }),
              ],
            );
          }),
        );
      },
    );
  }

  editToolsCategory(
    TextEditingController controller,
    PetToolCategoryModel category,
    mcontext,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(mcontext)!.edit_category),
              content: SizedBox(
                height: Dimensions.screenHeight / 3.5,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(mcontext)!
                            .enter_new_category_label,
                        //"Enter New Category label here",
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    GestureDetector(
                        onTap: () {
                          pickImages().then((value) => setState(() {}));
                        },
                        child: image != null
                            ? Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height30 * 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.radius10 / 2),
                                    ),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    image: DecorationImage(
                                        image: FileImage(image!))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              )
                            : Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height30 * 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.radius10 / 2),
                                    ),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            category.imageUrl))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${AppLocalizations.of(mcontext)!.hidden} : ",
                            style: TextStyles.labelTextStyle),
                        Icon(Icons.close, color: AppColors().primaryGreen),
                        Switch(
                            value: isHidden,
                            onChanged: (val) {
                              isHidden = val;
                              setState(() {});
                            }),
                        Icon(Icons.check_circle_rounded,
                            color: AppColors().primaryGreen),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.cancel),
                  onPressed: () {
                    controller.clear();
                    image = null;
                    refreshUI();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColorLight),
                    child: Text(AppLocalizations.of(mcontext)!.update),
                    onPressed: () {
                      globalToolsCubit.updateToolsCategory(
                        context,
                        PetToolCategoryModel(
                            label: label.text.isEmpty
                                ? category.label
                                : label.text,
                            imageUrl: image == null ? category.imageUrl : '',
                            id: category.id,
                            hidden: isHidden,
                            picture: image),
                      );
                      controller.clear();
                      image = null;
                      Navigator.of(context).pop();
                    }),
              ],
            );
          }),
        );
      },
    );
  }

  editCategory(
    TextEditingController controller,
    PetCategoryModel category,
    mcontext,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(mcontext)!.edit_category),
              content: SizedBox(
                height: Dimensions.screenHeight / 3.5,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(mcontext)!
                            .enter_new_category_label,
                        //"Enter New Category label here",
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    GestureDetector(
                        onTap: () {
                          pickImages().then((value) => setState(() {}));
                        },
                        child: image != null
                            ? Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height30 * 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.radius10 / 2),
                                    ),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    image: DecorationImage(
                                        image: FileImage(image!))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              )
                            : Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height30 * 3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.radius10 / 2),
                                    ),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.shade700),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            category.imageUrl))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${AppLocalizations.of(mcontext)!.hidden} : ",
                            style: TextStyles.labelTextStyle),
                        Icon(Icons.close, color: AppColors().primaryGreen),
                        Switch(
                            value: isHidden,
                            onChanged: (val) {
                              isHidden = val;
                              setState(() {});
                            }),
                        Icon(Icons.check_circle_rounded,
                            color: AppColors().primaryGreen),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.cancel),
                  onPressed: () {
                    controller.clear();
                    image = null;
                    refreshUI();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColorLight),
                    child: Text(AppLocalizations.of(mcontext)!.update),
                    onPressed: () {
                      globalPetCubit.updatePetCategory(
                        context,
                        PetCategoryModel(
                            label: label.text.isEmpty
                                ? category.label
                                : label.text,
                            imageUrl: image == null ? category.imageUrl : '',
                            id: category.id,
                            hidden: isHidden,
                            picture: image),
                      );
                      controller.clear();
                      image = null;
                      Navigator.of(context).pop();
                    }),
              ],
            );
          }),
        );
      },
    );
  }

  add(TextEditingController controller, mcontext, bool isPet, bool isTools,
      bool isFoods) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: isPet
                  ? Text(AppLocalizations.of(mcontext)!.add_new_pet_category)
                  : isTools
                      ? Text(
                          AppLocalizations.of(mcontext)!.add_new_tools_category)
                      : isFoods
                          ? Text(AppLocalizations.of(mcontext)!
                              .add_new_foods_category)
                          : const Text(''),
              content: SizedBox(
                height: Dimensions.screenHeight / 5,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(mcontext)!
                            .enter_new_category_label,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    GestureDetector(
                      onTap: () {
                        pickImages().then((value) => setState(() {}));
                      },
                      child: image != null
                          ? Container(
                              width: Dimensions.width30 * 3,
                              height: Dimensions.height30 * 3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimensions.radius10 / 2),
                                  ),
                                  border: Border.all(
                                      width: 1.5, color: Colors.grey.shade700),
                                  image: DecorationImage(
                                      image: FileImage(image!))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                            )
                          : Container(
                              width: Dimensions.width30 * 3,
                              height: Dimensions.height30 * 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radius10 / 2),
                                ),
                                border: Border.all(
                                    width: 1.5, color: Colors.grey.shade700),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Center(
                                  child: Icon(Icons.add,
                                      size: Dimensions.iconSize24,
                                      color: Colors.black)),
                            ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(
                    AppLocalizations.of(mcontext)!.cancel,
                  ),
                  onPressed: () {
                    controller.clear();
                    image = null;
                    refreshUI();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(
                    AppLocalizations.of(mcontext)!.add,
                  ),
                  onPressed: () {
                    if (image != null && controller.text.isNotEmpty) {
                      if (isPet) {
                        globalPetCubit.addNewPetCategory(
                            context, globalPets, controller.text, image!);
                      }
                      if (isTools) {
                        globalToolsCubit.addNewToolsCategory(context,
                            globalToolsCategories, controller.text, image!);
                      }
                      if (isFoods) {
                        globalPetFoodsCubit.addNewPetFoodsCategory(context,
                            globalPetFoodsCategories, controller.text, image!);
                      }
                      controller.clear();
                      image = null;
                      Navigator.of(context).pop();
                    } else {
                      showError(
                          mcontext,
                          AppLocalizations.of(mcontext)!
                              .error_the_Image_and_Label_must_be_filled_in);
                    }
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  refreshUI() => setState(() {});

  Future<void> pickImages() async {
    XFile? pImage = await picker.pickImage(source: ImageSource.gallery);
    if (pImage != null) {
      image = File(pImage.path);
      log(image!.path.toString());
    } else {
      image = null;
    }
    refreshUI();
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }
}
