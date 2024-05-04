import 'package:pet_house/core/services/service_locator.dart';
import 'package:flutter/material.dart';

class AppColors {
  final Color _lightBackgroundColor = hexToColor('#FBF8F0');
  Color get lightBackgroundColor => _lightBackgroundColor;

  final Color _primaryColorLight = const Color.fromRGBO(65, 109, 109, 1);
  Color get primaryColorLight => _primaryColorLight;

  final Color _primaryColorDark = const Color.fromRGBO(255, 250, 240, 1);
  Color get primaryColorDark => _primaryColorDark;

  final Color _backgroundColorLight = const Color.fromRGBO(255, 250, 240, 1);
  Color get backgroundColorLight => _backgroundColorLight;

  final Color _backgroundColorDark = const Color.fromRGBO(63, 63, 63, 1);
  Color get backgroundColorDark => _backgroundColorDark;

  // final Color _backgroundColorCardContainer = isDarkTheme
  //     ? AppColors().backgroundColorDark
  //     : AppColors().backgroundColorLight;
  Color get backgroundColorCardContainer => isDarkTheme
      ? AppColors().backgroundColorDark
      : AppColors().backgroundColorLight;

  // final Color _backgroundColorScaffold = isDarkTheme
  //     ? AppColors().backgroundColorDark
  //     : AppColors().backgroundColorLight;

  Color get backgroundColorScaffold => isDarkTheme
      ? AppColors().backgroundColorDark
      : AppColors().backgroundColorLight;

  // final Color _backgroundColorCircleAvatar = isDarkTheme
  //     ? AppColors().backgroundColorDark
  //     : AppColors().backgroundColorLight;

  Color get backgroundColorCircleAvatar => isDarkTheme
      ? AppColors().backgroundColorDark
      : AppColors().backgroundColorLight;

  // final Color _iconColor = isDarkTheme
  //     ? AppColors().primaryColorDark
  //     : AppColors().primaryColorLight;

  Color get iconColor => isDarkTheme
      ? AppColors().primaryColorDark
      : AppColors().primaryColorLight;

  // final Color _reIconColor = !isDarkTheme
  //     ? AppColors().primaryColorDark
  //     : AppColors().primaryColorLight;

  Color get reIconColor => !isDarkTheme
      ? AppColors().primaryColorDark
      : AppColors().primaryColorLight;

  // final Color _borderColor = isDarkTheme ? textColorDark : textColorLight;
  Color get borderColor => isDarkTheme ? textColorDark : textColorLight;

  // final Color _circularProgressIndicatorColor = isDarkTheme
  //     ? AppColors().primaryColorDark
  //     : AppColors().primaryColorLight;

  Color get circularProgressIndicatorColor => isDarkTheme
      ? AppColors().primaryColorDark
      : AppColors().primaryColorLight;

  // final Color _messageBackgroundColorBlue = isDarkTheme
  //     ? const Color.fromRGBO(33, 150, 243, 1)
  //     : const Color.fromARGB(255, 0, 140, 255);

  Color get messageBackgroundColorBlue =>isDarkTheme
      ? const Color.fromRGBO(33, 150, 243, 1)
      : const Color.fromARGB(255, 0, 140, 255);

  // final Color _messageBackgroundColorGrey = isDarkTheme
  //     ? const Color.fromRGBO(105, 105, 105, 1)
  //     : const Color.fromRGBO(96, 96, 96, 1);

  Color get messageBackgroundColorGrey =>  isDarkTheme
      ? const Color.fromRGBO(105, 105, 105, 1)
      : const Color.fromRGBO(96, 96, 96, 1);


  Color get textColorLight => Colors.black;

  Color get textColorDark => Colors.white;

  Color get textColorGreyLight => Colors.grey.shade500;
  Color get textColorGreyDark => Colors.white38;
  Color get textColorGrey => Colors.grey;
  Color get textColorWhite => Colors.white;
  Color get textColorblack54 => Colors.black54;
  Color get textColorWhite54 => Colors.white54;
  Color get textColorWhite5 => Colors.white.withOpacity(0.5);
  Color get textColorWhite8 => Colors.white.withOpacity(0.8);
  Color get textColorblack8 => Colors.black.withOpacity(0.8);
  Color get textColorblack5 => Colors.black.withOpacity(0.5);
  Color get textColorBlack => Colors.black;

  Color get storyHighlightColor => hexToColor("#F8C371");
  Color get primaryGreen => const Color(0xff416d6d);

  final List<BoxShadow> shadowList = [
    BoxShadow(
      color: Colors.grey.shade300,
      offset: const Offset(
        5.0,
        5.0,
      ),
      blurRadius: 10.0,
      spreadRadius: 2.0,
      //blurRadius: 1, offset: const Offset(0, 1),
    ),
    const BoxShadow(
      color: Colors.white,
      offset: Offset(0.0, 0.0),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ),
  ];
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));

  return Color(int.parse(hex.substring(1), radix: 16) +
      (hex.length == 7 ? 0xFF000000 : 0x00000000));
}
