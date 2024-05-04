import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/main.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List<Map> drawerItems = [
    {
      'icon': FontAwesomeIcons.paw,
      'title': 'Back to Home',
      'onTap': HOME_SCREEN,
    },
    {
      'icon': FontAwesomeIcons.plus,
      'title': 'Add New Item',
      'onTap': ADD_NEW_ITEM_SCREEN
    },
    {'icon': Icons.favorite, 'title': 'Favorites', 'onTap': FAVORITE_SCREEN},
    {'icon': Icons.mail, 'title': 'Messages', 'onTap': CHAT_SCREEN},
    {
      'icon': FontAwesomeIcons.userLarge,
      'title': 'Profile',
      'onTap': PROFILE_SCREEN
    },
    {'icon': Icons.settings, 'title': 'Settings', 'onTap': SETTINGS_SCREEN},
  ];
  String getTrLabel(String label) {
    switch (label) {
      case 'Back to Home':
        return AppLocalizations.of(context)!.back_to_Home;
            case 'Add New Item':
        return AppLocalizations.of(context)!.add_new_item;
              case 'Favorites':
        return AppLocalizations.of(context)!.favorites;
              case 'Messages':
        return AppLocalizations.of(context)!.messages;
              case 'Settings':
        return AppLocalizations.of(context)!.settings;  
           case 'Profile':
        return AppLocalizations.of(context)!.profile; 
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>()..getUserData(context),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors().backgroundColorScaffold,
            //Theme.of(context).primaryColor,
            image: const DecorationImage(
                image: AssetImage('assets/login.jpg'), fit: BoxFit.fill)),
        padding: const EdgeInsets.only(top: 50, bottom: 70, left: 10,right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return state is LoadedUserData
                    ? Row(
                        children: [
                          state.userModel.picture.isNotEmpty
                              ? CircleAvatar(
                                  radius: Dimensions.radius20,
                                  backgroundImage: CachedNetworkImageProvider(
                                      state.userModel.picture),
                                )
                              : CircleAvatar(
                                  radius: Dimensions.radius20,
                                  backgroundImage:
                                      const AssetImage("assets/profile.png"),
                                ),
                           SizedBox(
                            width: Dimensions.height10/2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Dimensions.screenWidth -
                                    Dimensions.width20 * 2,
                                child: Text(state.userModel.name.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.cardSubTitleTextStyle2),
                              ),
                              Text(
                                 AppLocalizations.of(context)!.active_Status,
                                  style: TextStyles.cardSubTitleTextStyle2)
                            ],
                          )
                        ],
                      )
                    : state is LoadingUserData
                        ? SizedBox(
                            width: Dimensions.width30,
                            height: Dimensions.width30,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: AppColors().circularProgressIndicatorColor,
                            )),
                          )
                        : SizedBox(
                            width: Dimensions.width30,
                            height: Dimensions.width30,
                            child: Text('ERROR',
                                style: TextStyles.cardSubTitleTextStyle2),
                          );
              },
            ),
            Column(
              children: drawerItems
                  .map((element) => Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: InkWell(
                          onTap: () {
                            if (element['title'] == 'Back to Home') {
                              Navigator.pushReplacementNamed(
                                  context, element["onTap"]);
                            } else {
                              Navigator.pushNamed(context, element["onTap"]);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                element['icon'],
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                getTrLabel(element['title']),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Row(
              children: [
                const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<UserCubit>(context, listen: false)
                          .signout(context);
                    },
                    child: state is LoadingUserData
                        ? SizedBox(
                            width: Dimensions.width30,
                            height: Dimensions.width30,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: AppColors().circularProgressIndicatorColor,
                            )),
                          )
                        :  Text(
                          AppLocalizations.of(context)!.signOut,
                         
                            style:const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
