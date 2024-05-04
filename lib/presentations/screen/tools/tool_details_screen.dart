import 'dart:convert';
import 'dart:developer';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/data/models/user_model.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/carousel_slider_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/presentations/widgets/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/tools/pet_tool_model.dart';

class ToolDetailsScreen extends StatefulWidget {
  final PetToolModel? tool;
  const ToolDetailsScreen({
    Key? key,
    this.tool,
  }) : super(key: key);

  @override
  State<ToolDetailsScreen> createState() => _ToolDetailsScreenState();
}

class _ToolDetailsScreenState extends State<ToolDetailsScreen> {
  //final CarouselController _controller = CarouselController();
  //int _current = 0;
  bool exist = false;
  bool isfav = false;
  late UserModel userModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    SharedPreferences shared = getIt();
    // uid = jsonDecode(shared.getString('user') ?? "")['_id'];
    final user = jsonDecode(shared.getString('user') ?? "");
    userModel = UserModel.fromjson(user);
    log(userModel.favourites.toString());
   for (var element in userModel.favourites) {
     //element = jsonDecode(element);
      if (element['favID'] == widget.tool!.id) {
        setState(() {
          isfav = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColorScaffold,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.screenHeight / 1.7,
              width: double.infinity,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.tool!.image.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CarsouelSliderWidget(
                                  pictures: widget.tool!.image,
                                )));
                      }
                    },
                    child: SizedBox(
                        height: Dimensions.screenHeight / 2.2,
                        width: double.infinity,
                        child: widget.tool!.image.isNotEmpty &&
                            widget.tool!.image[0].webViewLink.isNotEmpty
                            ? CachedImage(
                          imageUrl: widget.tool!.image[0].webViewLink,
                        )
                            : Container()),
                  ),
                  Positioned(
                      top: Dimensions.height20 * 2,
                      width:Dimensions.screenWidth,
                      child:Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: CircleAvatar(
                                  radius: Dimensions.radius15,
                                  backgroundColor:
                                  AppColors().backgroundColorCircleAvatar,
                                  child: Center(
                                      child:
                                      initLanguageCode == 'ar' ?
                                      Icon(
                                        Icons.arrow_circle_right_outlined,
                                        color: AppColors().iconColor,)
                                          :
                                      Icon(
                                        Icons.arrow_circle_left_outlined,
                                        color: AppColors().iconColor,

                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  report(context);
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: Dimensions.radius15,
                                      backgroundColor:
                                      AppColors().backgroundColorCircleAvatar,
                                      //Colors.white,
                                      child: Center(
                                          child: Icon(
                                            Icons.report_gmailerrorred_outlined,
                                            color: AppColors().iconColor,
                                            //Colors.black,
                                          )),
                                    ),
                                    SizedBox(height: Dimensions.height10 / 2),
                                    Text(
                                      AppLocalizations.of(context)!.report,
                                      //"Report",
                                      style: TextStyles.labelTextStyle,
                                    )
                                  ],
                                )),

                          ],
                        ),
                      )
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 200,
                      width: Dimensions.screenWidth - 40,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors().backgroundColorCardContainer,
                          boxShadow: AppColors().shadowList,
                          borderRadius:
                          BorderRadius.circular(Dimensions.radius15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.tool!.name,
                                  style: TextStyles.petNameStyle),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.merge_type,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              Text(widget.tool!.category,
                                  style: TextStyles.cardSubTitleTextStyle3
                                //.copyWith(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_sharp,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(widget.tool!.location,
                                  style: TextStyles.cardSubTitleTextStyle3
                                //.copyWith(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (isfav) {
                                    await globalUserCubit.removeFavItem(
                                        context, widget.tool!.id,'tool');
                                    isfav = false;
                                    setState(() {});
                                  } else {
                                    await globalUserCubit.addFavItem(
                                        context, widget.tool!.id,'tool');
                                    isfav = true;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 60,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: AppColors().primaryColorLight,
                                      //Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    isfav
                                        ? Icons.favorite_outlined
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => callNumber(
                                      number: widget.tool!.seller.phone),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: AppColors().primaryColorLight,
                                        //Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.call,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              widget.tool!.price == 0
                                                  ? AppLocalizations.of(context)!.call_for_Adoption

                                                  : AppLocalizations.of(context)!.call_for_Buy

                                              ,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimensions.font16),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.height10 * 5,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            widget.tool!.seller.picture.isEmpty
                                ? CircleAvatar(
                              radius: Dimensions.radius25,
                              backgroundImage:
                              const AssetImage("assets/profile.png"),
                            )
                                : CircleAvatar(
                              radius: Dimensions.radius25,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.tool!.seller.picture),
                            ),
                            Positioned(
                              right: 3,
                              child: userModel.id == widget.tool!.seller.id
                                  ? const CircleAvatar(
                                  radius: 5, backgroundColor: Colors.green)
                                  : CircleAvatar(
                                radius: 5,
                                backgroundColor: getIt
                                    .get<List<dynamic>>()
                                    .contains(widget.tool!.seller.id)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: Dimensions.width10 / 2),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(widget.tool!.seller.name,
                                      style: TextStyles.enjoyTextStyle
                                    //.copyWith(color: Colors.black),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.tool!.createdDate,
                                    style: TextStyles.cardSubTitleTextStyle2
                                        .copyWith(color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.owner,
                                    //"Owner",
                                    style: TextStyles.cardSubTitleTextStyle2
                                        .copyWith(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (userModel.id != widget.tool!.seller.id)
                                    GestureDetector(
                                      onTap: () {
                                        getIt.get<UserCubit>().accessChat(
                                            context, widget.tool!.seller.id);
                                      },
                                      child: Icon(Icons.chat,
                                          color: AppColors().iconColor
                                        //Theme.of(context).primaryColor,
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quantity
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        widget.tool!.quantity > 1
                            ? '${AppLocalizations.of(context)!.quantity} :  ${widget.tool!.quantity} ${AppLocalizations.of(context)!.tools}'
                            : '${AppLocalizations.of(context)!.quantity} :  ${widget.tool!.quantity} ${AppLocalizations.of(context)!.tool}',
                        style: TextStyles.labelTextStyle
                      //.copyWith(color: Colors.black),
                    ),
                  ),
                  //price
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        widget.tool!.price == 0
                            ? '${AppLocalizations.of(context)!.price} :  \$ ${widget.tool!.price}'
                            : '${AppLocalizations.of(context)!.price} :  \$ ${widget.tool!.price}',
                        style: TextStyles.labelTextStyle
                      //.copyWith(color: Colors.black),
                    ),
                  ),
                  // status
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '${AppLocalizations.of(context)!.status} :  ${widget.tool!.status}',
                      style: TextStyles.labelTextStyle,
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.description,
                      //'Description',
                      style: TextStyles.labelTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: RichText(
                      text: TextSpan(
                          text: widget.tool!.description,
                          style: TextStyles.cardSubTitleTextStyle3),
                    ),
                  ),
                  // seller
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.seller,
                      // 'Seller',
                      style: TextStyles.labelTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.text_fields_sharp,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: Dimensions.width15 / 2),
                              Text(widget.tool!.seller.name,
                                  style: TextStyles.cardSubTitleTextStyle3),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.phone,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: Dimensions.width15 / 2),
                              Text(widget.tool!.seller.phone,
                                  style: TextStyles.cardSubTitleTextStyle3),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.email,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: Dimensions.width15 / 2),
                              Text(widget.tool!.seller.email,
                                  style: TextStyles.cardSubTitleTextStyle3),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // // Whistleblower
                  // if (isAdmin)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 0, top: 10),
                  //     child: Text(
                  //       AppLocalizations.of(context)!.whistleblower,
                  //       // 'Whistleblower',
                  //       style: TextStyles.labelTextStyle,
                  //     ),
                  //   ),
                  // if (isAdmin)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //     child: ListView.separated(
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       shrinkWrap: true,
                  //       itemBuilder: (context, index) {
                  //         return ListTile(
                  //           shape: RoundedRectangleBorder(
                  //             side: BorderSide(
                  //                 width: 1.5, color: Colors.grey.shade700),
                  //             borderRadius:
                  //             BorderRadius.circular(Dimensions.radius10 / 2),
                  //           ),
                  //           leading: widget.tool!.reports[index].picture.isEmpty
                  //               ? CircleAvatar(
                  //             radius: Dimensions.radius20,
                  //             backgroundImage:
                  //             const AssetImage("assets/profile.png"),
                  //           )
                  //               : CircleAvatar(
                  //             radius: Dimensions.radius20,
                  //             backgroundImage: CachedNetworkImageProvider(
                  //                 widget.tool!.reports[index].picture),
                  //           ),
                  //           title: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Text(widget.tool!.reports[index].name,
                  //                   style: TextStyles.labelTextStyle),
                  //               Text(
                  //                   AppLocalizations.of(context)!.he_reported_this_item,
                  //                   //"He reported this item",
                  //                   style: TextStyles.descriptionTextStyle),
                  //             ],
                  //           ),
                  //           trailing: Icon(Icons.arrow_circle_right_outlined,
                  //               color: AppColors().primaryColorLight),
                  //           // onTap: () => Navigator.pushNamed(
                  //           //     context, REPORTED_PETS_SCREEN),
                  //         );
                  //       },
                  //       separatorBuilder: (context, index) =>
                  //           SizedBox(height: Dimensions.height10 / 2),
                  //       itemCount: widget.tool!.reports.length,
                  //     ),
                  //   ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }

  Future<dynamic> report(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext lcontext) {
        return StatefulBuilder(builder: (scontext, setState) {
          return AlertDialog(
            title:  Text(AppLocalizations.of(context)!.report
              //"Report"
            ),
            content: Text(
                AppLocalizations.of(context)!.do_you_want_report_this_item,
                //"Do you want report this item",
                style: TextStyles.labelTextStyle),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColorLight),
                child:  Text(AppLocalizations.of(context)!.close,
                  //"Close"
                ),
                onPressed: () {
                  Navigator.of(lcontext).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColorLight),
                child:  Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  globalUserCubit.addReportToItem(context, widget.tool!.id,'tool');
                  Navigator.of(lcontext).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  callNumber({required String number}) async {
    await FlutterPhoneDirectCaller.callNumber(number) ?? false;
  }
}
