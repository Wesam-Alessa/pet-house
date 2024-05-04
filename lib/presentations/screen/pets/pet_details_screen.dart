import 'dart:convert';

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
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/presentations/widgets/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PetDetailsScreen extends StatefulWidget {
  final PetModel? pet;
  const PetDetailsScreen({
    Key? key,
    this.pet,
  }) : super(key: key);

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
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
    for (var element in userModel.favourites) {
      //element = jsonDecode(element);
      if (element['favID'] == widget.pet!.id) {
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
                            if (widget.pet!.image.isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CarsouelSliderWidget(
                                            pictures: widget.pet!.image,
                                          )));
                            }
                          },
                          child: SizedBox(
                              height: Dimensions.screenHeight / 2.2,
                              width: double.infinity,
                              child: widget.pet!.image.isNotEmpty &&
                                      widget.pet!.image[0].webViewLink.isNotEmpty
                                  ? CachedImage(
                                      imageUrl: widget.pet!.image[0].webViewLink,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.pet!.name,
                                        style: TextStyles.petNameStyle),
                                    Icon(
                                      widget.pet!.gender == "male"
                                          ? Icons.male
                                          : Icons.female,
                                      color: AppColors().iconColor,
                                      //Theme.of(context).primaryColor,
                                      size: 22,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.merge_type,
                                          color: Theme.of(context).primaryColor,
                                          size: 18,
                                        ),
                                        Text(widget.pet!.category,
                                            style: TextStyles.cardSubTitleTextStyle3
                                            //.copyWith(color: Colors.grey.shade500),
                                            ),
                                      ],
                                    ),
                                    Text(
                                        widget.pet!.ageInYears != 0 &&
                                                widget.pet!.ageInMonths != 0
                                            ? '${widget.pet!.ageInYears}.${widget.pet!.ageInMonths} ${AppLocalizations.of(context)!.y_old}'
                                            : widget.pet!.ageInYears != 0 &&
                                                    widget.pet!.ageInMonths == 0
                                                ? '${widget.pet!.ageInYears} ${AppLocalizations.of(context)!.years_old}'
                                                : '${widget.pet!.ageInMonths} ${AppLocalizations.of(context)!.mounths_old}',
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
                                    Text(widget.pet!.location,
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
                                              context, widget.pet!.id,'pet');
                                          isfav = false;
                                          setState(() {});
                                        } else {
                                          await globalUserCubit.addFavItem(
                                              context, widget.pet!.id,'pet');
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
                                            number: widget.pet!.seller.phone),
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
                                                widget.pet!.price == 0
                                                    ? AppLocalizations.of(context)!.call_for_Adoption
                                                    //'Call for Adoption'
                                                    : AppLocalizations.of(context)!.call_for_Buy
                                                    //'Call to Buy',
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
                                  widget.pet!.seller.picture.isEmpty
                                      ? CircleAvatar(
                                          radius: Dimensions.radius25,
                                          backgroundImage:
                                              const AssetImage("assets/profile.png"),
                                        )
                                      : CircleAvatar(
                                          radius: Dimensions.radius25,
                                          backgroundImage: CachedNetworkImageProvider(
                                              widget.pet!.seller.picture),
                                        ),
                                  Positioned(
                                    right: 3,
                                    child: userModel.id == widget.pet!.seller.id
                                        ? const CircleAvatar(
                                            radius: 5, backgroundColor: Colors.green)
                                        : CircleAvatar(
                                            radius: 5,
                                            backgroundColor: getIt
                                                    .get<List<dynamic>>()
                                                    .contains(widget.pet!.seller.id)
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
                                        Text(widget.pet!.seller.name,
                                            style: TextStyles.enjoyTextStyle
                                            //.copyWith(color: Colors.black),
                                            ),
                                        const Spacer(),
                                        Text(
                                          widget.pet!.createdDate,
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
                                        if (userModel.id != widget.pet!.seller.id)
                                          GestureDetector(
                                            onTap: () {
                                              getIt.get<UserCubit>().accessChat(
                                                  context, widget.pet!.seller.id);
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
                              widget.pet!.quantity > 1
                                  ? '${AppLocalizations.of(context)!.quantity} :  ${widget.pet!.quantity} ${AppLocalizations.of(context)!.pets}'
                                  : '${AppLocalizations.of(context)!.quantity} :  ${widget.pet!.quantity} ${AppLocalizations.of(context)!.pet}',
                              style: TextStyles.labelTextStyle
                              //.copyWith(color: Colors.black),
                              ),
                        ),
                        //price
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                              widget.pet!.price == 0
                                  ? '${AppLocalizations.of(context)!.price} :  \$ ${widget.pet!.price}'
                                  : '${AppLocalizations.of(context)!.price} :  \$ ${widget.pet!.price}',
                              style: TextStyles.labelTextStyle
                              //.copyWith(color: Colors.black),
                              ),
                        ),
                        // status
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${AppLocalizations.of(context)!.status} :  ${widget.pet!.status}',
                            style: TextStyles.labelTextStyle,
                          ),
                        ),
                        // temperature
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${AppLocalizations.of(context)!.temperature} :  ${widget.pet!.temperature}',
                            style: TextStyles.labelTextStyle,
                          ),
                        ),
                        // PH
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${AppLocalizations.of(context)!.ph} :  ${widget.pet!.ph}',
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
                                text: widget.pet!.description,
                                style: TextStyles.cardSubTitleTextStyle3),
                          ),
                        ),
                        // vaccinations
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!.vaccinations,
                            //'Vaccinations',
                            style: TextStyles.labelTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: widget.pet!.vaccinations.isNotEmpty
                              ? Column(
                                  children: widget.pet!.vaccinations
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              Icon(Icons.vaccines,
                                                  color:
                                                      Theme.of(context).primaryColor),
                                              SizedBox(width: Dimensions.width15 / 2),
                                              Text(e.name,
                                                  style:
                                                      TextStyles.descriptionTextStyle),
                                              SizedBox(width: Dimensions.width15 / 2),
                                              Text( AppLocalizations.of(context)!.ex_date,
                                                //"EX Date :",
                                                  style:
                                                      TextStyles.descriptionTextStyle),
                                              SizedBox(width: Dimensions.width15 / 2),
                                              Text(e.expirationDate,
                                                  style: TextStyles
                                                      .cardSubTitleTextStyle3),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList())
                              : RichText(
                                  text: TextSpan(
                                      text:AppLocalizations.of(context)!.unspecified_Vaccinations,
                                      // "Unspecified Vaccinations",
                                      style: TextStyles.descriptionTextStyle),
                                ),
                        ),
                        // medicalHistory
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!.medical_history,
                            //'Medical History',
                            style: TextStyles.labelTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RichText(
                            text: TextSpan(
                                text: widget.pet!.medicalHistory,
                                style: TextStyles.cardSubTitleTextStyle3),
                          ),
                        ),
                        // sterile
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${AppLocalizations.of(context)!.sterile} : ${widget.pet!.sterilized}',
                            style: TextStyles.labelTextStyle,
                          ),
                        ),
                        // tags
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!.tags,
                            //'Tags',
                            style: TextStyles.labelTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: widget.pet!.tags.isNotEmpty
                              ? Column(
                                  children: widget.pet!.tags
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              Icon(Icons.tag,
                                                  color:
                                                      Theme.of(context).primaryColor),
                                              SizedBox(width: Dimensions.width15 / 2),
                                              Text(e,
                                                  style: TextStyles
                                                      .cardSubTitleTextStyle3),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList())
                              : RichText(
                                  text: TextSpan(
                                      text: AppLocalizations.of(context)!.unspecified_Tags,
                                      //"Unspecified Tags",
                                      style: TextStyles.descriptionTextStyle),
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
                                    Text(widget.pet!.seller.name,
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
                                    Text(widget.pet!.seller.phone,
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
                                    Text(widget.pet!.seller.email,
                                        style: TextStyles.cardSubTitleTextStyle3),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Whistleblower
                        if (isAdmin)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0, top: 10),
                            child: Text(
                              AppLocalizations.of(context)!.whistleblower,
                             // 'Whistleblower',
                              style: TextStyles.labelTextStyle,
                            ),
                          ),
                        if (isAdmin)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.5, color: Colors.grey.shade700),
                                    borderRadius:
                                        BorderRadius.circular(Dimensions.radius10 / 2),
                                  ),
                                  leading: widget.pet!.reports[index].picture.isEmpty
                                      ? CircleAvatar(
                                          radius: Dimensions.radius20,
                                          backgroundImage:
                                              const AssetImage("assets/profile.png"),
                                        )
                                      : CircleAvatar(
                                          radius: Dimensions.radius20,
                                          backgroundImage: CachedNetworkImageProvider(
                                              widget.pet!.reports[index].picture),
                                        ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(widget.pet!.reports[index].name,
                                          style: TextStyles.labelTextStyle),
                                      Text(
                                        AppLocalizations.of(context)!.he_reported_this_item,
                                        //"He reported this item",
                                          style: TextStyles.descriptionTextStyle),
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_circle_right_outlined,
                                      color: AppColors().primaryColorLight),
                                  // onTap: () => Navigator.pushNamed(
                                  //     context, REPORTED_PETS_SCREEN),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: Dimensions.height10 / 2),
                              itemCount: widget.pet!.reports.length,
                            ),
                          ),
                      ],
                    ),
                  )
                 ],
            ),
            // BlocBuilder<AppCubit, AppState>(builder: (context, state) {
            // if (state is LoadingPetDetails) {
            //   log("loading");
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            // if (state is ErrorPetDetails) {
            //   log("error");
            //   return const Center(
            //     child: Text("something wrong"),
            //   );
            // }
            // if (state is LoadedPetDetails) {
            //   log("loaded");
            //   log(state.pet.id);
            // List y = [widget.pet!.image];
            //return
            //             Stack(
            //   children: [
            //     Positioned(
            //       top: Dimensions.screenHeight / 1.9,
            //       child: Container(
            //         height: Dimensions.screenHeight / 3,
            //         width: Dimensions.screenWidth,
            //         padding: const EdgeInsets.all(10.0),
            //         child: SingleChildScrollView(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               // Consumer<UserProvider>(
            //               //   builder: (context, userProvider, _) {
            //               //     return userProvider.userProduct != null
            //               //         ?
            //               SizedBox(
            //                 height: Dimensions.height10 * 5,
            //                 child: Row(
            //                   children: [
            //                     CircleAvatar(
            //                       radius: Dimensions.radius25,
            //                       backgroundImage: const CachedNetworkImageProvider(
            //                           "https://media.istockphoto.com/id/1385109628/photo/affectionate-mother-reading-book-with-adorable-toddler-daughter.jpg?s=612x612&w=is&k=20&c=mWlXyXgrfZycxCfTNbdeUdiVjGbesOIOP8qTSe4sCdg="
            //                           // userProvider
            //                           //     .userProduct!.picture,
            //                           ),
            //                     ),
            //                     SizedBox(width: Dimensions.width10 / 2),
            //                     Flexible(
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                         children: [
            //                           Row(
            //                             children: [
            //                               Text(
            //                                 "Wesam",
            //                                 // userProvider
            //                                 //     .userProduct!.name,
            //                                 style: TextStyles.enjoyTextStyle
            //                                     .copyWith(color: Colors.black),
            //                               ),
            //                               const Spacer(),
            //                               Text(
            //                                 DateFormat('MMM d, h:mm a')
            //                                     .format(widget.pet!.createdDate
            //                                         // DateTime.parse(state
            //                                         //   .pet
            //                                         //   .createdDate.toString())
            //                                         ),
            //                                 style: TextStyles.cardSubTitleTextStyle2
            //                                     .copyWith(color: Colors.grey.shade500),
            //                               ),
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               Text(
            //                                 "Owner",
            //                                 style: TextStyles.cardSubTitleTextStyle2
            //                                     .copyWith(
            //                                   color: Colors.grey.shade500,
            //                                 ),
            //                               ),
            //                               const Spacer(),
            //                               // if (userProvider
            //                               //         .userProduct!.id !=
            //                               //     userProvider
            //                               //         .getUserModel.id)
            //                               //   GestureDetector(
            //                               //     onTap: () {
            //                               //       // var chat = Provider
            //                               //       //         .of<UserProvider>(
            //                               //       //             context,
            //                               //       //             listen:
            //                               //       //                 false)
            //                               //       //     .existChat(
            //                               //       //         frindId:
            //                               //       //             userProvider
            //                               //       //                 .userProduct!
            //                               //       //                 .id);
            //                               //       // chat.messages = chat
            //                               //       //     .messages.reversed
            //                               //       //     .toList();
            //                               //       // Navigator.pushNamed(
            //                               //       //     context,
            //                               //       //     MESSAGE_SCREEN,
            //                               //       //     arguments: chat);
            //                               //     },
            //                               //     child: Icon(
            //                               //       Icons.chat,
            //                               //       color:
            //                               //           Theme.of(context)
            //                               //               .primaryColor,
            //                               //     ),
            //                               //   )
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 //)
            //                 // : Container();
            //                 // },
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 10),
            //                 child: Text(
            //                   'Quantity : ${widget.pet!.viewCount}',
            //                   style: TextStyles.cardSubTitleTextStyle2
            //                       .copyWith(color: Colors.black),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 10),
            //                 child: Text(
            //                   'Description',
            //                   style: TextStyles.cardSubTitleTextStyle2
            //                       .copyWith(color: Colors.black),
            //                 ),
            //               ),
            //               Container(
            //                 height: Dimensions.screenHeight / 5.5,
            //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //                 child: SingleChildScrollView(
            //                   child: RichText(
            //                     text: TextSpan(
            //                         text: widget.pet!.description,
            //                         style: TextStyles.cardSubTitleTextStyle2
            //                             .copyWith(color: Colors.grey.shade500)),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //         width: double.infinity,
            //         height: Dimensions.screenHeight / 2.5,
            //         margin: const EdgeInsets.only(top: 30),
            //         child: CachedImage(imageUrl: widget.pet!.image.webViewLink)),
            //     Positioned(
            //       top: Dimensions.screenHeight / 2.65,
            //       child: Container(
            //         height: 100,
            //         width: Dimensions.screenWidth - 40,
            //         margin: const EdgeInsets.symmetric(horizontal: 20),
            //         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             boxShadow: shadowList,
            //             borderRadius: BorderRadius.circular(20)),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   widget.pet!.name,
            //                   style: TextStyles.subscriptionTitleTextStyle
            //                       .copyWith(color: Colors.black),
            //                 ),
            //                 Icon(
            //                   widget.pet!.gender == "male" ? Icons.male : Icons.female,
            //                   color: Theme.of(context).primaryColor,
            //                   size: 22,
            //                 )
            //               ],
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: [
            //                     Icon(
            //                       Icons.merge_type,
            //                       color: Theme.of(context).primaryColor,
            //                       size: 18,
            //                     ),
            //                     Text(
            //                       widget.pet!.category,
            //                       style: TextStyles.cardSubTitleTextStyle2
            //                           .copyWith(color: Colors.grey.shade500),
            //                     ),
            //                   ],
            //                 ),
            //                 Text(
            //                   widget.pet!.ageInYears != 0 &&
            //                           widget.pet!.ageInMonths != 0
            //                       ? '${widget.pet!.ageInYears}.${widget.pet!.ageInMonths} y old'
            //                       : widget.pet!.ageInYears != 0 &&
            //                               widget.pet!.ageInMonths == 0
            //                           ? '${widget.pet!.ageInYears} years old'
            //                           : '${widget.pet!.ageInMonths} mounths old',
            //                   style: TextStyles.cardSubTitleTextStyle2
            //                       .copyWith(color: Colors.grey.shade500),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: [
            //                 Icon(
            //                   Icons.location_on_sharp,
            //                   color: Theme.of(context).primaryColor,
            //                   size: 18,
            //                 ),
            //                 const SizedBox(width: 5),
            //                 Text(
            //                   widget.pet!.location,
            //                   style: TextStyles.cardSubTitleTextStyle2
            //                       .copyWith(color: Colors.grey.shade500),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Align(
            //       alignment: Alignment.bottomCenter,
            //       child: Container(
            //         margin: const EdgeInsets.symmetric(horizontal: 20),
            //         padding: const EdgeInsets.symmetric(horizontal: 15),
            //         height: 100,
            //         decoration: BoxDecoration(
            //           color: Colors.grey[200],
            //           borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(40),
            //             topRight: Radius.circular(40),
            //           ),
            //         ),
            //         child: Row(
            //           children: [
            //             // Consumer<UserProvider>(builder: (context, provider, _) {
            //             //   exist = provider.getUserModel.favourites
            //             //       .contains(widget.pet!.id);
            //             // return
            //             GestureDetector(
            //               onTap: () {
            //                 // if (exist) {
            //                 //   provider.removeFromFavourites(
            //                 //       favItemId: widget.pet!.id);
            //                 // } else {
            //                 //   provider.addToFavourites(
            //                 //       productId: widget.pet!.id);
            //                 // }
            //               },
            //               child: Container(
            //                 height: 60,
            //                 width: 70,
            //                 decoration: BoxDecoration(
            //                     color: Theme.of(context).primaryColor,
            //                     borderRadius: BorderRadius.circular(20)),
            //                 child: Icon(
            //                   exist ? Icons.favorite_outlined : Icons.favorite_border,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //               //);
            //               // }
            //             ),
            //             const SizedBox(
            //               width: 10,
            //             ),
            //             Expanded(
            //               child: GestureDetector(
            //                 onTap: () => callNumber(number: widget.pet!.seller.phone),
            //                 child: Container(
            //                   height: 60,
            //                   decoration: BoxDecoration(
            //                       color: Theme.of(context).primaryColor,
            //                       borderRadius: BorderRadius.circular(20)),
            //                   child: Center(
            //                       child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                     children: [
            //                       const Icon(
            //                         Icons.call,
            //                         color: Colors.white,
            //                       ),
            //                       Text(
            //                         widget.pet!.price == 0
            //                             ? 'Call for Adoption'
            //                             : 'Call to Buy',
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: Dimensions.font16),
            //                       ),
            //                     ],
            //                   )),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top: 40, left: 5),
            //       child: Align(
            //         alignment: Alignment.topLeft,
            //         child:
            //             // Row(
            //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //   children: [
            //             // ClipRRect(
            //             //   // borderRadius: Dimensions.radius15,
            //             //   borderRadius: BorderRadius.circular(Dimensions.radius15),
            //             //   child: const Icon(Icons.arrow_back_ios),
            //             // ),
            //             GestureDetector(
            //           onTap: () => Navigator.pushReplacementNamed(context, HOME_SCREEN),
            //           child: const CircleAvatar(
            //             backgroundColor: Colors.white,
            //             child: Center(
            //                 child: Icon(
            //               Icons.arrow_back_ios_new,
            //               color: Colors.black,
            //             )),
            //           ),
            //         ),
            //         // IconButton(
            //         //     color: Colors.grey,
            //         //     icon: const Icon(Icons.arrow_back_ios),
            //         //     onPressed: () {
            //         //       Navigator.pop(context);
            //         //     }),
            //         // Flexible(
            //         //   child: Row(
            //         //     mainAxisAlignment: MainAxisAlignment.center,
            //         //     children:
            //         //         // state.pet.image
            //         //         y.asMap().entries.map((entry) {
            //         //       return GestureDetector(
            //         //         onTap: () => _controller.animateToPage(entry.key),
            //         //         child: Container(
            //         //           width: 12.0,
            //         //           height: 12.0,
            //         //           margin: const EdgeInsets.symmetric(
            //         //               vertical: 8.0, horizontal: 4.0),
            //         //           decoration: BoxDecoration(
            //         //               shape: BoxShape.circle,
            //         //               color: (Theme.of(context).brightness ==
            //         //                           Brightness.dark
            //         //                       ? Colors.white
            //         //                       : Colors.black)
            //         //                   .withOpacity(
            //         //                       _current == entry.key ? 0.9 : 0.4)),
            //         //         ),
            //         //       );
            //         //     }).toList(),
            //         //   ),
            //         // ),
            //         //],
            //         // ),
            //       ),
            //     ),
            //   ],
            //)
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
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColorLight),
                child:  Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  globalUserCubit.addReportToItem(context, widget.pet!.id,'pet');
                  Navigator.of(context).pop();
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
