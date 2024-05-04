import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/presentations/widgets/cached_network_image.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';

import '../../../data/models/tools/pet_tool_model.dart';
import '../../screen/tools/tool_details_screen.dart';

class ToolCardWidget extends StatelessWidget {
  final PetToolModel tool;
  final int index;
  const ToolCardWidget({Key? key, required this.tool, required this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ToolDetailsScreen(
                    tool: tool,
                  )));
        },
        child: Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: AppColors().backgroundColorCardContainer,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.blueGrey[300]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors().shadowList,
                  ),
                  child:
                  tool.image.isNotEmpty && tool.image[0].webViewLink.isNotEmpty
                      ? CachedImage(imageUrl: tool.image[0].webViewLink)
                      : Container(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: AppColors().backgroundColorCardContainer,
                      boxShadow: AppColors().shadowList,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          tool.name,
                          style: TextStyles.subscriptionTitleTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(tool.location,
                                style: TextStyles.cardSubTitleTextStyle3),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors().iconColor,
                            ),
                          ],
                        ),
                        Text(
                          tool.createdDate,
                          style: TextStyles.cardSubTitleTextStyle3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (tool.price == 0)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Text("For Adoption",
                                    style: TextStyles.body3TextStyle
                                  //.copyWith(color: Colors.white),
                                ),
                              ),


                            ],
                          ),
                        if (tool.price != 0)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Text("${tool.price} JOD",
                                    style: TextStyles.body3TextStyle
                                  //.copyWith(color: Colors.white),
                                ),
                              ),

                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
