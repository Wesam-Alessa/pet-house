// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, implementation_imports

import 'dart:convert';

import 'package:pet_house/presentations/controllers/pet_foods/pet_foods_cubit.dart';
import 'package:pet_house/presentations/controllers/tools/tools_cubit.dart';
import 'package:pet_house/presentations/screen/admin/closed_accounts_screen.dart';
import 'package:pet_house/presentations/screen/admin/objection_reports_screen.dart';
import 'package:pet_house/presentations/screen/admin/waiting_foods_screen.dart';
import 'package:pet_house/presentations/screen/admin/waiting_tools_screen.dart';
import 'package:pet_house/presentations/screen/foods/add_new_food_screen.dart';
import 'package:pet_house/presentations/screen/manager/feedback_reports_screen.dart';
import 'package:pet_house/presentations/screen/manager/status_of_officials_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/src/cupertino_localizations.dart';
import 'package:flutter_localizations/src/material_localizations.dart';
import 'package:flutter_localizations/src/widgets_localizations.dart';
import 'package:pet_house/presentations/screen/primates/add_new_item_screen.dart';
import 'package:pet_house/presentations/screen/loading_screen.dart';
import 'package:pet_house/presentations/screen/tools/add_new_tool_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/presentations/controllers/App/app_cubit.dart';
import 'package:pet_house/presentations/controllers/logic_screen.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/screen/pets/add_new_pet_screen.dart';
import 'package:pet_house/presentations/screen/admin/reported_pets_screen.dart';
import 'package:pet_house/presentations/screen/admin/waiting_pets_screen.dart';
import 'package:pet_house/presentations/screen/auth/signin_screen.dart';
import 'package:pet_house/presentations/screen/auth/signup_screen.dart';
import 'package:pet_house/presentations/screen/pets/category_screen.dart';
import 'package:pet_house/presentations/screen/conversation/chat_screen.dart';
import 'package:pet_house/presentations/screen/conversation/message_screen.dart';
import 'package:pet_house/presentations/screen/favourite_screen.dart';
import 'package:pet_house/presentations/screen/home_screen.dart';
import 'package:pet_house/presentations/screen/main_screen.dart';
import 'package:pet_house/presentations/screen/manager/item_deletion_reports_screen.dart';
import 'package:pet_house/presentations/screen/pets/pet_details_screen.dart';
import 'package:pet_house/presentations/screen/profile_screen.dart';
import 'package:pet_house/presentations/screen/search_screen.dart';
import 'package:pet_house/presentations/screen/settings_screen.dart';
import 'package:pet_house/presentations/screen/splash_screen.dart';

import 'core/languages/l10n.dart';
//import 'firebase_options.dart';
import 'presentations/screen/pets/update_pet_post_screen.dart';

String LOGIC_SCREEN = 'logic-screen';
String SPLASH_SCREEN = 'splash-screen';
String MY_APP_SCREEN = 'my-app-screen';
String MAIN_SCREEN = 'main-screen';
String SIGNIN_SCREEN = 'login-screen';
String SIGNUP_SCREEN = 'signup-screen';
String PET_DETAILS_SCREEN = 'pet-details-screen';
String HOME_SCREEN = 'home-screen';
String FAVORITE_SCREEN = 'fav-screen';
String ADD_NEW_ITEM_SCREEN = 'add-new-item-screen';
String ADD_NEW_PET_SCREEN = 'add-new-pet-screen';
String ADD_NEW_TOOL_SCREEN = 'add-new-tool-screen';
String ADD_NEW_FOOD_SCREEN = 'add-new-food-screen';
String CATEGORY_SCREEN = 'category-screen';
String CHAT_SCREEN = 'chat-screen';
String MESSAGE_SCREEN = 'message-screen';
String PROFILE_SCREEN = 'profile-screen';
String SEARCH_SCREEN = 'search-screen';
String UPDATE_POST_SCREEN = 'update-post-screen';
String SETTINGS_SCREEN = 'settings-screen';
String WAITING_PETS_SCREEN = 'waiting-screen';
String REPORTED_ITEMS_SCREEN = 'reported-items-screen';
String ITEM_DELETION_REPORTS_SCREEN = 'item-deletion-reports-screen';
String FEEDBACK_REPORTS_SCREEN = 'feedback-reports-screen';
String STATUS_OF_OFFICIALS_SCREEN = 'status-of-officials-screen';
String CLOSED_ACCOUNTS_SCREEN = 'closed-accounts-screen';
String OBJECTION_REPORTS_SCREEN = 'objection-reports-screen';
String WAITING_TOOLS_SCREEN= 'waiting-tools-screen';
String WAITING_FOODS_SCREEN= 'waiting-foods-screen';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await ServicesLocator().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    isDarkTheme =
        getIt.get<SharedPreferences>().getBool('isDarkTheme') ?? false;
    initLanguageCode =
        getIt.get<SharedPreferences>().getString('initLanguageCode') ?? 'en';
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isBackground = state == AppLifecycleState.paused;
    final isResumed = state == AppLifecycleState.resumed;
    SharedPreferences shared = getIt();
    String userId = jsonDecode(shared.getString('user') ?? "")['_id'];
    if (isBackground) {
      gsocket.emit("user disconnect", userId);
    }
    if (isResumed) {
      gsocket.emit("re-connect", userId);

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet House',
      supportedLocales: L10n.all,
      locale: Locale(initLanguageCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      theme: ThemeData(
          primaryColor: isDarkTheme
              ? AppColors().primaryColorDark
              : AppColors().primaryColorLight),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(
              create: (BuildContext context) => getIt.get<UserCubit>()),
          BlocProvider<PetCubit>(
              create: (BuildContext context) => getIt.get<PetCubit>()),
          BlocProvider<ToolsCubit>(
              create: (BuildContext context) =>
                  getIt.get<ToolsCubit>()),
          BlocProvider<PetFoodsCubit>(
              create: (BuildContext context) =>
                  getIt.get<PetFoodsCubit>()),
          BlocProvider<AppCubit>(
            create: (BuildContext context) =>
                getIt.get<AppCubit>()..init(context),
          ),
        ],
        child: const
        //LoadingScreen()
            //SignInScreen()
            Splashscreen(),
      ),
      routes: {
        LOGIC_SCREEN: (context) => const LogicScreen(),
        SPLASH_SCREEN: (context) => const Splashscreen(),
        MY_APP_SCREEN: (context) => const MyApp(),
        HOME_SCREEN: (context) => const HomeScreen(),
        MAIN_SCREEN: (context) => const MainScreen(),
        SIGNIN_SCREEN: (context) => const SignInScreen(),
        SIGNUP_SCREEN: (context) => const SignUpScreen(),
        PET_DETAILS_SCREEN: (context) => const PetDetailsScreen(pet: null),
        FAVORITE_SCREEN: (context) => const FavoriteScreen(),
        ADD_NEW_ITEM_SCREEN: (context) => const AddNewItemScreen(),
        ADD_NEW_PET_SCREEN: (context) => const AddNewPetScreen(),
        ADD_NEW_TOOL_SCREEN: (context) => const AddNewToolScreen(),
        ADD_NEW_FOOD_SCREEN: (context) => const AddNewFoodScreen(),
        CATEGORY_SCREEN: (context) => const CategoryScreen(catName: ''),
        CHAT_SCREEN: (context) => const ChatScreen(),
        MESSAGE_SCREEN: (context) => const MessageScreen(chat: null),
        PROFILE_SCREEN: (context) => const ProfileScreen(),
        SEARCH_SCREEN: (context) => const SearchScreen(),
        UPDATE_POST_SCREEN: (context) => const UpdatePetPostScreen(),
        SETTINGS_SCREEN: (context) => const SettingsScreen(),
        WAITING_PETS_SCREEN: (context) => const WaitingPetScreen(),
        WAITING_TOOLS_SCREEN: (context) => const WaitingToolsScreen(),
        WAITING_FOODS_SCREEN: (context) => const WaitingFoodsScreen(),
        REPORTED_ITEMS_SCREEN: (context) => const ReportedItemsScreen(),
        ITEM_DELETION_REPORTS_SCREEN: (context) =>
            const ItemDeletionReportsScreen(),
        FEEDBACK_REPORTS_SCREEN: (context) => const FeedbackReportsScreen(),
        STATUS_OF_OFFICIALS_SCREEN: (context) =>
            const StatusOfOfficialsScreen(),
        CLOSED_ACCOUNTS_SCREEN: (context) => const ClosedAccountsScreen(),
        OBJECTION_REPORTS_SCREEN: (context) => const ObjectionReportsScreen(),
      },
    );
  }
// bool active = false;

// @override
// void initState() {
//   FirebaseAuth.instance.authStateChanges().listen((User? user) {
//     if (user == null) {
//       //setState(() {
//         active = false;
//      // });
//     } else {
//       setState(() {
//         active = true;
//       });
//     }
//   });
//   super.initState();
// }

// @override
// Widget build(BuildContext context) {
//   return MultiProvider(
//     providers: [
//       ChangeNotifierProvider.value(value: UserProvider.initialized()),
//       ChangeNotifierProvider.value(value: AppProvider()),
//       ChangeNotifierProvider.value(
//           value: ProductProvider.initialize(context: context)),
//     ],
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Pet House',
//       theme: ThemeData(
//         primaryColor: const Color.fromRGBO(65, 109, 109, 1),
//       ),
//       home: active ? const HomeScreen() : const LoginScreen(),
//       routes: {
//         MY_APP_SCREEN: (context) => const MyApp(),
//         HOME_SCREEN: (context) => const HomeScreen(),
//         MAIN_SCREEN: (context) => const MainScreen(),
//         LOGIN_SCREEN: (context) => const LoginScreen(),
//         SIGNUP_SCREEN: (context) => const SignUpScreen(),
//         AD_DETAILS_SCREEN: (context) => const PostDetailsScreen(),
//         FAVORITE_SCREEN: (context) => const FavoriteScreen(),
//         ADD_NEW_PET_SCREEN: (context) => const AddNewPetScreen(),
//         CATEGORY_SCREEN: (context) => const CategoryScreen(),
//         CHAT_SCREEN: (context) => const ChatScreen(),
//         MESSAGE_SCREEN: (context) => const MessageScreen(),
//         PROFILE_SCREEN: (context) => const ProfileScreen(),
//         SEARCH_SCREEN: (context) => const SearchScreen(),
//         UPDATE_POST_SCREEN: (context) =>  const UpdatePetPostScreen(),

//       },
//     ),
//   );
// }
}
