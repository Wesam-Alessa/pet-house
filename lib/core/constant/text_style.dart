// ignore_for_file: prefer_const_constructors

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();

  static TextStyle get petNameStyle => TextStyle(
      fontSize: Dimensions.font26,
      fontWeight: FontWeight.w800,
      color: isDarkTheme ? AppColors().textColorDark : AppColors().textColorLight,
      fontFamily: 'Ubuntu');

  static TextStyle get labelTextStyle => TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w600,
      color: isDarkTheme ? AppColors().textColorDark : AppColors().textColorLight,
      fontFamily: 'Ubuntu');

  static TextStyle get descriptionTextStyle => TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w600,
      color: isDarkTheme ? AppColors().textColorDark : AppColors().textColorLight,
      fontFamily: 'Ubuntu');

  static TextStyle get nameTextStyle => TextStyle(
      fontSize: Dimensions.font12 * 2,
      fontWeight: FontWeight.w700,
      color: isDarkTheme ? AppColors().textColorDark : AppColors().textColorLight,
      fontFamily: 'Ubuntu');

  static TextStyle get subNameTextStyle => TextStyle(
      fontSize: Dimensions.font18,
      fontWeight: FontWeight.w600,
      color: AppColors().textColorGrey,
      fontFamily: 'Ubuntu');

  static TextStyle get sectionNameTextStyle => TextStyle(
      fontSize: Dimensions.font20,
      fontWeight: FontWeight.bold,
      color: !isDarkTheme ? AppColors().textColorLight : AppColors().textColorDark,
      fontFamily: 'Ubuntu');

  static TextStyle get categoryLabelTextStyle => TextStyle(
      fontSize: Dimensions.font12 * 2,
      fontWeight: FontWeight.bold,
      color: AppColors().textColorDark,
      //!isDarkTheme ? AppColors.textColorLight :
      fontFamily: 'Ubuntu');

  static TextStyle get formLabelTextStyle => TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w600,
      color:
          isDarkTheme ? AppColors().textColorWhite54 : AppColors().textColorblack54,
      fontFamily: 'Ubuntu');

  static TextStyle get appNameTextStyle => TextStyle(
      fontSize: Dimensions.font26,
      //26,
      fontWeight: FontWeight.w800,
      color:
          isDarkTheme ? AppColors().textColorWhite8 : AppColors().textColorblack8,
      fontFamily: 'Ubuntu');

  static TextStyle get tageLineStyle => TextStyle(
      fontSize: Dimensions.font12,
      // 12,
      fontWeight: FontWeight.w800,
      color: isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get signinTageLineStyle => TextStyle(
      fontSize: Dimensions.font12,
      // 12,
      fontWeight: FontWeight.w800,
      color: AppColors().textColorWhite ,
      fontFamily: 'Ubuntu');      

  static TextStyle get bigHeadingTextStyle => TextStyle(
      fontSize: Dimensions.font20 * 2.5,
      //50,
      fontWeight: FontWeight.bold,
      color: isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get bodyTextStyle => TextStyle(
      fontSize: Dimensions.font14,
      //14,
      fontWeight: FontWeight.w400,
      color: isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get enjoyTextStyle => TextStyle(
      fontSize: Dimensions.font18,
      // 18,
      fontWeight: FontWeight.w900,
      color: isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get subscriptionTitleTextStyle => TextStyle(
      fontSize: Dimensions.font20,
      // 20,
      fontWeight: FontWeight.w800,
      color: isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get titleTextStyle => TextStyle(
      fontSize: Dimensions.font12 * 2,
      //24,
      fontWeight: FontWeight.w700,
      color: isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get signinTextStyle => TextStyle(
      fontSize: Dimensions.font12 * 2,
      
      fontWeight: FontWeight.w700,
      color: AppColors().textColorWhite ,
      fontFamily: 'Ubuntu');
  // static final TextStyle body2TextStyle = TextStyle(
  //     fontSize: Dimensions.font16,
  //     // 16,
  //     letterSpacing: 1.3,
  //     fontWeight: FontWeight.w400,
  //     color: isDarkTheme ?  AppColors.textColorWhite5 : AppColors.textColorblack5,
  //     fontFamily: 'Ubuntu');

  static TextStyle get body3TextStyle => TextStyle(
      fontSize: Dimensions.font12,
      //12,
      fontWeight: FontWeight.w300,
      color:
          //Colors.white,
          !isDarkTheme ? AppColors().textColorWhite : AppColors().textColorBlack,
      fontFamily: 'Ubuntu');

  static TextStyle get cardSubTitleTextStyle => TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: isDarkTheme
          ? AppColors().textColorWhite8
          : AppColors().textColorGreyLight,
      fontFamily: 'Ubuntu');

  static TextStyle get messageTextStyle => TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      // isDarkTheme
      //     ? AppColors.textColorWhite8
      //     : AppColors.textColorGreyLight,
      fontFamily: 'Ubuntu');

  static TextStyle get cardSubTitleTextStyle2 => TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w600,
      color: AppColors().textColorWhite8,
      //isDarkTheme ? AppColors().textColorWhite8 : AppColors().textColorblack8,
      //  isDarkTheme ?  : AppColors.textColorblack8,
      fontFamily: 'Ubuntu');

  static TextStyle get cardSubTitleTextStyle3 => TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w600,
      color:
          isDarkTheme ? AppColors().textColorWhite5 : AppColors().textColorblack5,
      fontFamily: 'Ubuntu');

  static TextStyle get textFormFieldWidgetStyle => TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w600,
      color:
          isDarkTheme ? AppColors().textColorWhite8 : AppColors().textColorblack8,
      fontFamily: 'Ubuntu');
}
