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

import '../../../data/models/foods/pet_foods_model.dart';

class FoodDetailsScreen extends StatefulWidget {
  final PetFoodsModel? food;
  const FoodDetailsScreen({
    Key? key,
    this.food,
  }) : super(key: key);

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
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
      if (element['favID'] == widget.food!.id) {
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
                      if (widget.food!.image.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CarsouelSliderWidget(
                                  pictures: widget.food!.image,
                                )));
                      }
                    },
                    child: SizedBox(
                        height: Dimensions.screenHeight / 2.2,
                        width: double.infinity,
                        child: widget.food!.image.isNotEmpty &&
                            widget.food!.image[0].webViewLink.isNotEmpty
                            ? CachedImage(
                          imageUrl: widget.food!.image[0].webViewLink,
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
                              Text(widget.food!.name,
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
                              Text(widget.food!.category,
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
                              Text(widget.food!.location,
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
                                        context, widget.food!.id,'food');
                                    isfav = false;
                                    setState(() {});
                                  } else {
                                    await globalUserCubit.addFavItem(
                                        context, widget.food!.id,'food');
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
                                      number: widget.food!.seller.phone),
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
                                              widget.food!.price == 0
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
                            widget.food!.seller.picture.isEmpty
                                ? CircleAvatar(
                              radius: Dimensions.radius25,
                              backgroundImage:
                              const AssetImage("assets/profile.png"),
                            )
                                : CircleAvatar(
                              radius: Dimensions.radius25,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.food!.seller.picture),
                            ),
                            Positioned(
                              right: 3,
                              child: userModel.id == widget.food!.seller.id
                                  ? const CircleAvatar(
                                  radius: 5, backgroundColor: Colors.green)
                                  : CircleAvatar(
                                radius: 5,
                                backgroundColor: getIt
                                    .get<List<dynamic>>()
                                    .contains(widget.food!.seller.id)
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
                                  Text(widget.food!.seller.name,
                                      style: TextStyles.enjoyTextStyle
                                    //.copyWith(color: Colors.black),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.food!.createdDate,
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
                                  if (userModel.id != widget.food!.seller.id)
                                    GestureDetector(
                                      onTap: () {
                                        getIt.get<UserCubit>().accessChat(
                                            context, widget.food!.seller.id);
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
                        widget.food!.quantity > 1
                            ? '${AppLocalizations.of(context)!.quantity} :  ${widget.food!.quantity} ${AppLocalizations.of(context)!.foods}'
                            : '${AppLocalizations.of(context)!.quantity} :  ${widget.food!.quantity} ${AppLocalizations.of(context)!.food}',
                        style: TextStyles.labelTextStyle
                      //.copyWith(color: Colors.black),
                    ),
                  ),
                  //price
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        widget.food!.price == 0
                            ? '${AppLocalizations.of(context)!.price} :  \$ ${widget.food!.price}'
                            : '${AppLocalizations.of(context)!.price} :  \$ ${widget.food!.price}',
                        style: TextStyles.labelTextStyle
                      //.copyWith(color: Colors.black),
                    ),
                  ),
                  // status
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '${AppLocalizations.of(context)!.status} :  ${widget.food!.status}',
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
                          text: widget.food!.description,
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
                              Text(widget.food!.seller.name,
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
                              Text(widget.food!.seller.phone,
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
                              Text(widget.food!.seller.email,
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
                  //           leading: widget.food!.reports[index].picture.isEmpty
                  //               ? CircleAvatar(
                  //             radius: Dimensions.radius20,
                  //             backgroundImage:
                  //             const AssetImage("assets/profile.png"),
                  //           )
                  //               : CircleAvatar(
                  //             radius: Dimensions.radius20,
                  //             backgroundImage: CachedNetworkImageProvider(
                  //                 widget.food!.reports[index].picture),
                  //           ),
                  //           title: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Text(widget.food!.reports[index].name,
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
                  //       itemCount: widget.food!.reports.length,
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
                  globalUserCubit.addReportToItem(context, widget.food!.id,'food');
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
