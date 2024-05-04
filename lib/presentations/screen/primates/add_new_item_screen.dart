import 'package:flutter/cupertino.dart';
import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pet_house/main.dart';




class AddNewItemScreen extends StatefulWidget {

  const AddNewItemScreen({Key? key,}) : super(key: key);

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text(
            AppLocalizations.of(context)!.add_new_item,
            style: TextStyles.titleTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          physics:const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  side:
                  BorderSide(width: 1.5, color: AppColors().borderColor),
                  borderRadius:
                  BorderRadius.circular(Dimensions.radius10 / 2),
                ),
                leading: Icon(Icons.pets,
                    color: AppColors().iconColor),
                title: Text(
                  AppLocalizations.of(context)!.add_new_pet,
                  style: TextStyles.textFormFieldWidgetStyle,
                ),
                trailing: Icon(Icons.add, color: AppColors().iconColor),
                onTap: () =>
                    Navigator.pushNamed(context, ADD_NEW_PET_SCREEN),
              ),
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  side:
                  BorderSide(width: 1.5, color: AppColors().borderColor),
                  borderRadius:
                  BorderRadius.circular(Dimensions.radius10 / 2),
                ),
                leading: Icon(Icons.pan_tool_outlined,
                    color: AppColors().iconColor),
                title: Text(
                  AppLocalizations.of(context)!.add_new_tool,
                  style: TextStyles.textFormFieldWidgetStyle,
                ),
                trailing: Icon(Icons.add, color: AppColors().iconColor),
                onTap: () =>
                    Navigator.pushNamed(context, ADD_NEW_TOOL_SCREEN),
              ),
                const SizedBox(height: 10),
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                    BorderSide(width: 1.5, color: AppColors().borderColor),
                    borderRadius:
                    BorderRadius.circular(Dimensions.radius10 / 2),
                  ),
                  leading: Icon(Icons.food_bank_outlined,
                      color: AppColors().iconColor),
                  title: Text(
                    AppLocalizations.of(context)!.add_new_food,
                    style: TextStyles.textFormFieldWidgetStyle,
                  ),
                  trailing: Icon(Icons.add, color: AppColors().iconColor),
                  onTap: () =>
                      Navigator.pushNamed(context, ADD_NEW_FOOD_SCREEN),
                ),
            ],
            ),
          ),
        ),);
  }
}
