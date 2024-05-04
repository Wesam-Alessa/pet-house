import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/tools/tools_cubit.dart';
import '../../widgets/tools/tool_card_widget.dart';



class ToolsCategoryScreen extends StatefulWidget {
  final String catName;
  const ToolsCategoryScreen({Key? key, required this.catName}) : super(key: key);

  @override
  State<ToolsCategoryScreen> createState() => _ToolsCategoryScreenState();
}

class _ToolsCategoryScreenState extends State<ToolsCategoryScreen> {
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
        body: BlocBuilder<ToolsCubit, ToolsState>(
            bloc: getIt.get<ToolsCubit>()..getTools(context, widget.catName),
            builder: (context, state) {
              if (state is LoadingToolsState) {
                return Center(
                    child: CircularProgressIndicator(
                      color: AppColors().circularProgressIndicatorColor,
                    ));
              }
              if (state is LoadedToolsState) {
                return state.tools.isNotEmpty
                    ? Directionality(
                  textDirection: TextDirection.ltr,
                  child: SizedBox(
                    height: Dimensions.screenHeight * 0.67,
                    width: double.infinity,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: state.tools.length,
                      itemBuilder: (context, index) {
                        return ToolCardWidget(
                          index: index,
                          tool: state.tools[index],
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
